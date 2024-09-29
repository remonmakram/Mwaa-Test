# -*- coding: utf-8 -*-
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
from airflow.hooks.base_hook import BaseHook 
import oracledb
import logging
from contextlib import closing
from datetime import datetime, timezone
import pandas as pd
from airflow.exceptions import AirflowException
from airflow.providers.oracle.hooks.oracle import OracleHook
from airflow.models import BaseOperator
#from airflow.utils.decorators import apply_defaults
import pytz

class OracleMergePDWOperator(BaseOperator):
    """
    Merge date from one Oracle table (Landing table) to another Oracle table (Staging table)
    :param dest_table: reference to a specific schema and table in Oracle database. Example:"ODS_STAGE.SF_ACCOUNT_STG"
    :type dest_table: string
    :param src_table: reference to a specific schema and table in Oracle database. Example:"ODS_APP_USER.SF_AIRFLOW_ACCOUNT_LND"
    :type src_table: string
    :param oracle_conn_id: reference to used Oracle connection. Example:"'PDW_AssetUpload'"
    :type oracle_conn_id: OracleHook
    :param log_ods_table_name: Utilized log table. Default value is "ODS_OWN.AIRFLOW_PACKAGESTATS"
    :type log_ods_table_name: string
    :param excluded_columns: list of columns to excluded "'column1', 'column2', ..."
    :type excluded_columns: string
    :param unique_keys: Unique keys used for join. If sql expression should be used then dictionary should be used.
    :type unique_keys: string list or list of dictionaries {'FieldName': 'ID2', 'expression': "isnull('{FieldName}', '')"}
    :param operations_to_apply: Identified which operations should be applied. "Insert,Update"
    :type operations_to_apply: string
    :param pre_sql: contains sql command to be run at start of load
    :type pre_sql: string
    :param post_sql: contains sql comand to be run at end of load
    :type post_sql: string
    :param cdc_log_mode: contains which value will be saved into log table cdc_completion_date column. 'Oracle_sysdate' or 'UTC_Date'
    :type cdc_log_mode: string
    :param insert_sys_date_columns: List of columns which should be populated with SYSDATE on INSERT. ['ODS_CREATE_DATE', 'ODS_MODIFY_DATE']
    :type insert_sys_date_columns: string list
    :param update_sys_date_columns: List of columns which should be populated with SYSDATE on UPDATE. ['ODS_MODIFY_DATE']
    :type update_sys_date_columns: string list
    """
    template_fields = ('pre_sql', 'post_sql')
    template_ext = ('.sql',)
    ui_color = '#ededed'

    #@apply_defaults
    def __init__(
            self,
            dest_table,
            src_table,
            oracle_conn_id,
            log_ods_table_name = 'ODS_OWN.AIRFLOW_PACKAGESTATS',
            excluded_columns = "'ODS_CREATE_DATE', 'ODS_MODIFY_DATE'",
            excluded_columns_if_out_of_source=[],
            unique_keys = [],
            operations_to_apply = 'Insert,Update',
            pre_sql = None,
            post_sql = None,
            cdc_log_mode = 'Oracle_sysdate', ###UTC_Date,
            insert_sys_date_columns = ['ODS_CREATE_DATE', 'ODS_MODIFY_DATE'],
            update_sys_date_columns = ['ODS_MODIFY_DATE'],
            skip_merge = False,
            time_zone = 'US/Central',
            *args, **kwargs):
        super(OracleMergePDWOperator, self).__init__(*args, **kwargs)
        self.dest_table = dest_table
        self.src_table = src_table
        self.oracle_conn_id = oracle_conn_id
        self.pre_sql = pre_sql
        self.post_sql = post_sql
        self.log_ods_table_name = log_ods_table_name
        self.unique_keys = unique_keys
        self.operations_to_apply = operations_to_apply
        self.cdc_log_mode = cdc_log_mode
        self.insert_sys_date_columns = insert_sys_date_columns
        self.update_sys_date_columns = update_sys_date_columns
        self.excluded_columns_if_out_of_source = excluded_columns_if_out_of_source
        self.time_zone = time_zone

        self.dest_table_schema = self.parse_schema(dest_table).upper()
        self.dest_table_name = self.parse_tablename(dest_table).upper()

        self.src_table_schema = self.parse_schema(src_table).upper()
        self.src_table_name = self.parse_tablename(src_table).upper()
        self.skip_merge = skip_merge
        
        if excluded_columns is not None:
            self.excluded_columns = excluded_columns.upper()
        else:
            self.excluded_columns = excluded_columns

    def parse_schema(self, table_name):
        return table_name.split('.')[0]

    def parse_tablename(self, table_name):
        return table_name.split('.')[1]

    def connect(self):
        connection = BaseHook.get_connection(self.oracle_conn_id)       
        dsn = f"""  
        (DESCRIPTION=  
            (ADDRESS=  
                (PROTOCOL=TCP)  
                (HOST={connection.host})  
                (PORT={connection.port})  
            )  
            (CONNECT_DATA=  
                (SERVICE_NAME={connection.schema})  
            )  
            (RETRY_COUNT=3)  
            (RETRY_DELAY=3)  
            (EXPIRE_TIME=4)  
        )
        """  
        oracle_config = {  
            "user": connection.login,  
            "password": connection.password,  
            "dsn": dsn,  
        }
        print("-------------------------------------------")
        print(oracle_config)
        print(oracledb.version)
        print("-------------------------------------------")

        conn = oracledb.connect(**oracle_config)
        conn.autocommit = True
        return conn
    
    def execute_sql (self, sqlcmd):
        print('Executing Sql: ' + str(sqlcmd))
        with closing(self.connect()) as conn:
            with closing(conn.cursor()) as cursor:
                cursor.execute(sqlcmd)
                # cursor.commit()
                return cursor.rowcount

    def execute_sql_with_logging(self, input_sql, query_title):
        # execute only if string non empty
        if input_sql:
            if len(input_sql.strip()) > 0:
                logging.info("Starting %s execution ..." % query_title)
                SQLCount = self.execute_sql(input_sql)
                logging.info("Affected row count: %d" % SQLCount)
                logging.info("Finished %s execution ..." % query_title)

    def get_utc_start_date(self):
        self.utc_start_time = datetime.now(self.time_zone).replace(tzinfo=None)
        print('UTC start time: {0}'.format(self.utc_start_time))

    def get_oracle_sysdate(self):
        print('Querying Oracle SYSDATE...')
        query = "SELECT SYSDATE FROM dual"
        print('Executing Query: ' + str(query))
        with closing(self.connect()) as conn:
            with closing(conn.cursor()) as cursor:
                cursor.execute(query)
                row = cursor.fetchone()
                oracle_sysdate = row[0]
                print('Oracle SYSDATE Result: {0}'.format(oracle_sysdate))
                return oracle_sysdate

    def get_cdc_date(self):
        print('Getting new CDC Date...')
        if self.cdc_log_mode == 'Oracle_sysdate':
            cdc_date = self.oracle_sys_date
        elif self.cdc_log_mode == 'UTC_Date':
            cdc_date = self.utc_start_time
        else:    
            cdc_date = None
        
        print('cdc_log_mode is {0}; cdc_date is {1}'.format(self.cdc_log_mode, cdc_date))
        if cdc_date is None:
            raise AirflowException('CDC Date is not defined for provided cdc_log_mode: {}'.format(self.cdc_log_mode))
        return cdc_date

    def insert_packagestats_on_finish(self, rows_inserted = 0, rows_updated = 0, rows_deleted = 0):
        insert_query = """
            BEGIN
                INSERT INTO {0}
                (
                      process_name
                    , schema_name
                    , table_name
                    , step
                    , dag_id
                    , start_timestamp
                    , completion_timestamp
                    , cdc_completion_date
                    , rows_inserted
                    , rows_updated
                    , rows_deleted
                )
                VALUES
                (
                      '{1}' -- process_name
                    , '{2}' -- schema_name
                    , '{3}' -- table_name
                    , 'Cntrl' -- step
                    , '{9}' -- dag_id
                    , to_date('{4}', 'yyyy-mm-dd hh24:mi:ss') -- start_timestamp
                    , SYSDATE -- completion_timestamp
                    , to_date('{5}', 'yyyy-mm-dd hh24:mi:ss') -- cdc_completion_date
                    , {6} -- rows_inserted
                    , {7} -- rows_updated
                    , {8} -- rows_deleted
                )
                RETURNING package_stats_sk INTO :v_package_stats_sk;
            END;
            """.format(self.log_ods_table_name, self.task_id, self.dest_table_schema, self.dest_table_name,
                       self.oracle_sys_date.strftime("%Y-%m-%d %H:%M:%S"), self.cdc_date.strftime("%Y-%m-%d %H:%M:%S"),
                       rows_inserted, rows_updated, rows_deleted, self.dag_id)
        
        print('Package Stats Insert Query:')
        print(insert_query)
        with closing(self.connect()) as conn:
            conn.autocommit = True
            with closing(conn.cursor()) as cursor:
                v_package_stats_sk = cursor.var(int)
                cursor.execute(insert_query, v_package_stats_sk = v_package_stats_sk)
                package_stats_sk = v_package_stats_sk.getvalue()
                print('Inserted package_stats_sk value: {0}'.format(package_stats_sk))
                return package_stats_sk

    
    def execute_oracle_select(self, query):
        """
        The method will take a select statement and return pandas dataframe
        :param: statement: string contains select statement
        
        """
        cursor = None
        try:
            with closing(self.connect()) as conn:
                with closing(conn.cursor()) as cursor:
                    cursor.execute(query)
                    result = cursor.fetchall()
                    columns = [col[0] for col in cursor.description]
                    df = pd.DataFrame(result, columns=columns)
                    return df
        except oracledb.DatabaseError as e:
            print(f"Error executing Oracle statement: {e}")
            raise
    
    def get_columns(self):
        columns_query = """SELECT COLUMN_ID, COLUMN_NAME as TARGETCOLUMNNAME
            FROM ALL_TAB_COLS
            WHERE OWNER = '{0}'
            and TABLE_NAME = '{1}'""".format(self.dest_table_schema, self.dest_table_name)

        if self.excluded_columns is not None:
            ex_cols =  self.excluded_columns
            # ex_cols_str = ','.join([f"'{x}'" for x in ex_cols.split(",")])
            ex_cols_str = ','.join([f"'{x.strip()}'" for x in ex_cols.split(",")])
            print(f'ex_cols_str = {ex_cols_str}')
            columns_query = str(columns_query) + '\n and  column_name not in ({0})'.format(ex_cols_str)

        print(f"get_columns = {columns_query}")

        if len(self.excluded_columns_if_out_of_source) > 0:
            ef = self.get_excluded_columns_if_out_of_source()
            ef_str = ','.join([f"'{x}'" for x in ef])
            if len(ef) > 0:
                columns_query = str(columns_query) + '\n and  column_name not in ({0})'.format(ef_str)
            else:
                print(f'No additionally excluded fields. Initial input: {self.excluded_columns_if_out_of_source}')

        columns_query = str(columns_query) + '\n ORDER BY column_id'
        print('Column Query: ' + str(columns_query))
        
        # df = self.oracle.get_pandas_df(columns_query)
        df = self.execute_oracle_select(columns_query)
        print('Number of extracted columns: {0}'.format(len(df)))
        print('List of extracted columns:')
        print(', '.join(df['TARGETCOLUMNNAME'].tolist()))
        if len(df) == 0:
            raise AirflowException('No fields for merge was found. Please, check destination table name configuration!!!')
            
        df['SOURCECOLUMNNAME'] = df['TARGETCOLUMNNAME']
        df['SOURCECOLUMNNAME_QUOTED'] = df.apply(lambda x: '"{0}"'.format(x['SOURCECOLUMNNAME']), axis = 1)
        df['TARGETCOLUMNNAME_QUOTED'] = df.apply(lambda x: '"{0}"'.format(x['TARGETCOLUMNNAME']), axis = 1)
        
        return df

    def preprocess_unique_keys(self):
        unique_keys = []
        for k in self.unique_keys:
            if isinstance(k, str):
                unique_keys.append({'FieldName':k.strip()})
            elif isinstance(k, dict):
                if 'FieldName' in k.keys():
                    unique_keys.append(k)
                else:
                    raise AirflowException("Unique key should contains key 'FieldName' if defined as dictionary in parameter unique_keys")
            else:
                raise AirflowException(
                    'Parameter [unique_keys] is incorrectly configured. Please, fix.')
        return unique_keys

    def parse_unique_keys(self):
        unique_keys = self.preprocess_unique_keys()
        self.key_fields = [f['FieldName'].upper() for f in unique_keys]
        self.join_clause = self.get_join_condition(unique_keys)

    def get_join_condition(self, unique_keys):
        join_clause = ''
        fieldNameTag = '{FieldName}'

        expression_list = []
        for k in unique_keys:
            expr = k.get('expression', '')
            key = k['FieldName']

            full_source_field = '{0}.{1}'.format('S', key)
            full_target_field = '{0}.{1}'.format('T', key)

            if expr == '':
                source_field = full_source_field
                target_field = full_target_field
            else:
                source_field = expr.replace(fieldNameTag, full_source_field)
                target_field = expr.replace(fieldNameTag, full_target_field)

            expression_list.append('{0} = {1}'.format(source_field, target_field))

        if len(expression_list) > 0:
            join_clause = ' and '.join(expression_list)

        return join_clause

    def build_insert_query(self):
        df = self.df_columns
        
        target_fields_list = df['TARGETCOLUMNNAME_QUOTED'].tolist()
        print(f"target_fields_list = {target_fields_list}")

        source_fields_list = df['SOURCECOLUMNNAME_QUOTED'].tolist()
        source_fields_list_alias = ('S' + '.' + df['SOURCECOLUMNNAME_QUOTED']).tolist()
     
        for f in self.insert_sys_date_columns:
            target_fields_list.append(f)
            source_fields_list.append('SYSDATE')
            source_fields_list_alias.append('SYSDATE')

        target_fields = ', '.join(target_fields_list)
        source_fields = ', '.join(source_fields_list)
        source_fields_alias= ', '.join(source_fields_list_alias)

        if len(self.unique_keys) > 0:
            insert_query = """
                MERGE INTO {0} T
                USING
                (
                    select * from {1}
                ) S ON ({2})
                WHEN NOT MATCHED THEN INSERT
                (
                    {3}
                )
                VALUES
                (
                    {4}
                )""".format(self.dest_table, self.src_table, self.join_clause, target_fields, source_fields_alias)
        else:
            insert_query = """
                INSERT INTO {0}
                (
                    {2}
                )
                SELECT
                    {3}
                FROM {1}""".format(self.dest_table, self.src_table, target_fields, source_fields)
        
        return insert_query

    def build_update_query(self):
        no_fields_for_update = True
        df = self.df_columns
        excluded_fields = self.key_fields
        df_no_keys = df.query('TARGETCOLUMNNAME not in @excluded_fields')
        print(f"excluded_fields {excluded_fields} , df_no_keys =  {df_no_keys}")

        set_rows = []
        where_rows = []
        for index, row in df_no_keys.iterrows():
            no_fields_for_update = False
            set_row = '{0}.{1} = {2}.{3}'.format('T', row['TARGETCOLUMNNAME'], 'S', row['SOURCECOLUMNNAME'])
            where_row = 'DECODE({0}.{1}, {2}.{3}, 1, 0) = 0'.format('T', row['TARGETCOLUMNNAME'], 'S', row['SOURCECOLUMNNAME'])
            set_rows.append(set_row)
            where_rows.append(where_row)

        for f in self.update_sys_date_columns:
            set_rows.append('{0}.{1} = SYSDATE'.format('T', f))

        set_clause = ", \n".join(set_rows)
        where_clause = "\n or ".join(where_rows)

        update_query = """
            MERGE INTO {0} T
            USING
            (
                select * from {1}
            ) S ON ({2})
            WHEN MATCHED THEN UPDATE
            SET
            {3}
            WHERE
            {4}
            """.format(self.dest_table, self.src_table, self.join_clause, set_clause, where_clause)

        skip_update = True if no_fields_for_update else False
        return update_query, skip_update

    def exec_insert_query(self):
        row_count = 0
        if 'Insert' in self.operations_to_apply:
            print('Applying INSERT operation...')
            query = self.build_insert_query()
            row_count =  self.execute_sql(query)
            print('Rows Inserted: {0}'.format(row_count))
        else:
            print("Insert operation is not applied.")
        return row_count

    def exec_update_query(self):
        row_count = 0
        
        if self.operations_to_apply is not None and 'Update' in self.operations_to_apply:
            if len(self.unique_keys) > 0:
                print('Applying UPDATE operation...')
                query, skip_update = self.build_update_query()
                if skip_update:
                    print('No fields for update is found in table. Only unique keys are found. Update will be skippped!!!')
                else:
                    row_count =  self.execute_sql(query)
                    print('Rows Updated: {0}'.format(row_count))
            else:
                raise AirflowException(
                    "'unique_keys' parameter should be specified for update operation")
        else:
            print("Update operation is not applied.")
        
        return row_count

    def get_excluded_columns_if_out_of_source(self):
        excluded_fields = []
        if len(self.excluded_columns_if_out_of_source) > 0:
            print(f'Checking excluded_columns_if_out_of_source: {self.excluded_columns_if_out_of_source}')
            for ef in self.excluded_columns_if_out_of_source:
                field = ef.upper()
                check_query = """SELECT count(*)
                    FROM ALL_TAB_COLS
                    WHERE OWNER = '{0}'
                        and TABLE_NAME = '{1}'
                        and COLUMN_NAME = '{2}'""".format(self.src_table_schema, self.src_table_name, field)
                # res = self.oracle.get_first(check_query)[0]
                res = self.execute_oracle_select(check_query).iloc[0, 0] 
                print(f'Query result: {res}')
                if res == 0:
                    excluded_fields.append(field)

        if len(excluded_fields) > 0:
            print(f'Additional excluded fields: {excluded_fields}')
        return excluded_fields

    def print_input_params(self):
        print(f'dest_table: {self.dest_table}')
        print(f'src_table: {self.src_table}')
        print(f'excluded_columns: {self.excluded_columns}')
        print(f'operations_to_apply: {self.operations_to_apply}')
        print(f'unique_keys: {self.unique_keys}')
        print(f'insert_sys_date_columns: {self.insert_sys_date_columns}')
        print(f'update_sys_date_columns: {self.update_sys_date_columns}')

    def execute(self, context):
        if self.skip_merge:
            print(f'Skip Merge: {self.skip_merge}')
            print('Operator is configured to do nothing!!!')
        else:
            self.print_input_params()
            # self.oracle = OracleHook(oracle_conn_id=self.oracle_conn_id)
            # connection = self.oracle.get_conn()
            # print(f" Current Connection username {connection.username}")
            self.get_utc_start_date()
            self.oracle_sys_date = self.get_oracle_sysdate()
            self.cdc_date = self.get_cdc_date()
            self.parse_unique_keys()
            self.df_columns = self.get_columns()

            self.execute_sql_with_logging(self.pre_sql, "Pre-sql")
            rows_updated = self.exec_update_query()
            rows_inserted = self.exec_insert_query()
            self.execute_sql_with_logging(self.post_sql, "Post-sql")

            self.package_stats_sk = self.insert_packagestats_on_finish(rows_inserted=rows_inserted,
                                                                       rows_updated=rows_updated)
