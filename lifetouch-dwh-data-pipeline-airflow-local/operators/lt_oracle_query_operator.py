from __future__ import annotations
from typing import Any, Callable, Iterable, Mapping, NoReturn, Sequence
from contextlib import closing, contextmanager
import sqlparse
from airflow.providers.common.sql.hooks.sql import fetch_all_handler
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
import re
from datetime import datetime
import oracledb
from airflow.hooks.base_hook import BaseHook 

class OracleSQLQueryOperator(SQLExecuteQueryOperator):
    template_fields: Sequence[str] = ("conn_id", "sql", "parameters", "hook_params", "pre_sql")
    template_ext: Sequence[str] = (".sql", ".json")
    template_fields_renderers = {"sql": "sql", "parameters": "json"}
    ui_color = "#cdaaed"

    def __init__(
            self,
            sql: str | list[str],
            pre_sql: Mapping = {},
            autocommit: bool = True,
            parameters: Mapping | Iterable | None = None,
            handler: Callable[[Any], Any] = fetch_all_handler,
            conn_id: str | None = None,
            database: str | None = None,
            split_statements: bool | None = None,
            return_last: bool = True,
            show_return_value_in_logs: bool = False,
            time_zone='US/Central',
            session_no=None,
            RETRY_COUNT = 3,
            RETRY_DELAY = 3,
            EXPIRE_TIME = 4,
            *args, **kwargs,
    ) -> None:
        self.time_zone = time_zone
        self.sql = self._read_sql(sql)
        self.pre_sql = self._read_pre_sql(pre_sql)
        self.session_no = session_no
        self.conn_id = conn_id
        self.RETRY_COUNT = RETRY_COUNT
        self.RETRY_DELAY = RETRY_DELAY
        self.EXPIRE_TIME = EXPIRE_TIME
        super().__init__(
            sql=self.sql,
            conn_id=conn_id,
            database=database,
            *args,
            autocommit=autocommit,
            parameters=parameters,
            handler=handler,
            split_statements=split_statements,
            return_last=return_last,
            show_return_value_in_logs=show_return_value_in_logs,
            **kwargs,
        )

    def _read_sql(self, sql: str | list[str]) -> str:
        """
        Read SQL from file if it ends with .sql, otherwise return as-is.
        """
        if isinstance(sql, list):
            return '\n'.join([self._read_sql(s) for s in sql])
        elif isinstance(sql, str) and sql.endswith('.sql'):
            return self._read_file(sql)
        else:
            return sql

    def _read_pre_sql(self, pre_sql: Mapping) -> Mapping:
        """
        Read pre_sql from files if they end with .sql, otherwise return as-is.
        """
        result = {}
        for placeholder, pre_sql_statement in pre_sql.items():
            if isinstance(pre_sql_statement, str) and pre_sql_statement.endswith('.sql'):
                result[placeholder] = self._read_file(pre_sql_statement)
            else:
                result[placeholder] = pre_sql_statement
        return result

    def _read_file(self, file_path: str) -> str:
        """
        Read content from a file.
        """
        with open(file_path, 'r') as file:
            return file.read()

    @contextmanager
    def _create_autocommit_connection(self):
        oracledb.init_oracle_client()
        connection = BaseHook.get_connection(self.conn_id)       
        dsn = f"""(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST={connection.host})(PORT={connection.port}))(CONNECT_DATA=(SERVICE_NAME={connection.schema}))(RETRY_COUNT={self.RETRY_COUNT})(RETRY_DELAY={self.RETRY_DELAY})(EXPIRE_TIME={self.EXPIRE_TIME}))"""  
        oracle_config = {  
            "user": connection.login,  
            "password": connection.password,  
            "dsn": dsn,  
        }  
        
        conn = oracledb.connect(**oracle_config)
        conn.autocommit = True
        # self.log.info("conn from oracledb: %s", conn)
        yield conn
  
    
    @staticmethod
    def split_sql_string(sql):
        """
        Split string into multiple SQL expressions.

        :param sql: SQL string potentially consisting of multiple expressions
        :return: list of individual expressions
        """
        splits = sqlparse.format(sql, strip_comments=True).split("&")

        # Remove leading/trailing whitespace and empty statements
        splits = [statement.strip() for statement in splits if statement.strip()]

        return splits
    
    def _run_command(self, cur, sql_statement, parameters):

        """Run a statement using an already open cursor."""
        # self.log.info("Running statement: %s, parameters: %s", sql_statement, parameters)
        self.log.info("parameters: %s", parameters)

        if parameters:
            for key, value in parameters.items():
                self.log.info("k: %s - v: %s", key, value)
                if isinstance(value, str):
                    sql_statement = re.sub(f":{key}", f"'{value}'", sql_statement)
                else:
                    sql_statement = re.sub(f":{key}", str(value), sql_statement)

        sql_statement = "".join([s for s in sql_statement.strip().splitlines(True) if s.strip()])

        self.log.info("the final sql query: %s", sql_statement)

        cur.execute(sql_statement)

        # According to PEP 249, this is -1 when query result is not applicable.
        if cur.rowcount >= 0:
            self.log.info("Rows affected: %s", cur.rowcount)

    def _run_command_with_output(self, cur, sql_statement, parameters):
        """Run a statement using an already open cursor."""
        self.log.info("Running pre-requisite statement: %s, parameters: %s", sql_statement, parameters)

        if parameters:
            for key, value in parameters.items():
                self.log.info("k: %s - v: %s", key, value)
                if isinstance(value, str):
                    sql_statement = re.sub(f":{key}", f"'{value}'", sql_statement)
                else:
                    sql_statement = re.sub(f":{key}", str(value), sql_statement)
        sql_statement = "".join([s for s in sql_statement.strip().splitlines(True) if s.strip()])
        self.log.info("the final sql query: %s", sql_statement)
        cur.execute(sql_statement)
        # According to PEP 249, this is -1 when query result is not applicable.
        if cur.rowcount >= 0:
            self.log.info("Rows affected: %s", cur.rowcount)

        # Fetch the results if the query returns any
        if cur.description:
            result = cur.fetchall()
            self.log.info("Query result: %s", result)
            return result
        else:
            return None

    def extract_and_filter_parameters(self, sql_query, parameters, context):
        """
        Extracts parameters from a SQL query and filters them from a JSON object.

        Parameters:
        - sql_query (str): The SQL query containing parameters.
        - parameters (json): The JSON data as a string.

        Returns:
        - dict: A dictionary containing the filtered parameters.
        """
        # Extract parameters from the SQL query
        sql_extracted_params = re.findall(r':(\w+)', sql_query)
        if 'v_sess_no' in sql_extracted_params:
            parameters['v_sess_no'] = self.session_no #int(datetime.now(self.time_zone).timestamp() * 1000)
        if 'v_sess_beg' in sql_extracted_params:
            # dag_beg_timestamp = context['ts']
            # parsed_datetime = datetime.fromisoformat(dag_beg_timestamp)
            # # Convert the datetime object to the desired format
            # formatted_datetime_str = parsed_datetime.strftime("%Y-%m-%d %H:%M:%S.%f")
            # parameters['v_sess_beg'] = formatted_datetime_str
            parameters['v_sess_beg'] = datetime.now(self.time_zone).strftime('%Y-%m-%d %H:%M:%S.%f')

        # Filter the parameters from the JSON object
        filtered_params = {key: parameters[key] for key in sql_extracted_params if key in parameters}

        return filtered_params

    def format_date_string(self, datetime: list):
        if len(datetime) > 0:

            # Extract the datetime object from the string
            dt = datetime[0][0]

            # Format the datetime object to the desired string format
            formatted_datetime = dt.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
        else:
            formatted_datetime = '2010-01-01 00:00:00.000'

        return formatted_datetime

    def execute(self, context):
        self.log.info("Executing: %s", self.sql)
        # db_hook = self.get_db_hook()
        sql = self.sql
        split_statements = self.split_statements
        autocommit = self.autocommit
        parameters = self.parameters

        if isinstance(sql, str):
            if split_statements:
                sql_list: Iterable[str] = self.split_sql_string(sql)
            else:
                sql_list = [sql] if sql.strip() else []
        else:
            sql_list = sql

        if sql_list:
            self.log.debug("Executing following statements against DB: %s", sql_list)
        else:
            raise ValueError("List of SQL statements is empty")

        # select parameters for the query

        with self._create_autocommit_connection() as conn:
            with closing(conn.cursor()) as cur:

                # execute pre-sql queries
                for placeholder, pre_sql_statement in self.pre_sql.items():
                    # filtering the parameters for the running query from all the parameters
                    filtered_parameters = self.extract_and_filter_parameters(pre_sql_statement, self.parameters,
                                                                             context)
                    sql_output = self._run_command_with_output(cur, pre_sql_statement, filtered_parameters)
                    type = sql_output[0][1] if len(sql_output) > 0 and len(sql_output[0]) > 1 else None
                    self.parameters[placeholder] = self.format_date_string(
                        sql_output) if type is not None and type == 'date' else sql_output[0][0]

                # execute sql query
                for sql_statement in sql_list:
                    # filtering the parameters for the running query from all the parameters
                    filtered_parameters = self.extract_and_filter_parameters(sql_statement, self.parameters, context)
                    self._run_command(cur, sql_statement, filtered_parameters)

            # If autocommit was set to False or db does not support autocommit, we do a manual commit.
            # if not db_hook.get_autocommit(conn):
            #     conn.commit()

        return None
