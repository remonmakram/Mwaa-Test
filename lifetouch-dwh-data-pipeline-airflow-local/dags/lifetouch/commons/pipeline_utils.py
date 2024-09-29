import itertools
from datetime import datetime, timedelta, timezone
import boto3
import botocore
import pendulum
import logging
import boto3
import yaml
import json
import os
from airflow import DAG
from airflow.models import Variable, Connection
from airflow.operators.python import PythonOperator, ShortCircuitOperator, BranchPythonOperator
from airflow.operators.empty import EmptyOperator
from airflow.utils.task_group import TaskGroup
from airflow.providers.amazon.aws.operators.glue import GlueJobOperator
from airflow.providers.databricks.operators.databricks import DatabricksSubmitRunOperator
from airflow.providers.databricks.operators.databricks import DatabricksCreateJobsOperator, DatabricksRunNowOperator
from airflow.providers.databricks.hooks.databricks import DatabricksHook
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.providers.oracle.operators.oracle import OracleOperator
from airflow.providers.oracle.operators.oracle import OracleOperator
from airflow.providers.ssh.operators.ssh import SSHOperator
from airflow.sensors.python import PythonSensor
from botocore.exceptions import ClientError
from decimal import Decimal
from boto3.dynamodb.conditions import Key
from airflow.providers.oracle.hooks.oracle import OracleHook
from operators.lt_oracle_query_operator import OracleSQLQueryOperator
from operators.lt_oracle_merge_pdw_operator import OracleMergePDWOperator
from airflow.models import DagRun
from airflow import settings
from sqlalchemy import and_
import pytz
import time
import operator
from contextlib import closing
from airflow.operators.dummy import DummyOperator
import re
import oracledb

v_retries = 2
v_retry_delay = timedelta(hours=1)
v_readbatchsize = 50000
v_writebatchsize = 10000

# environment
v_environment = Variable.get("Environment", default_var="dev")

# aws region
v_country = Variable.get("Country", default_var="US").lower()
if v_country == "us":
    aws_region = "us-east-1"
    region_code = "-"
else:
    aws_region = "ca-central-1"
    region_code = "-ca-"

# v_databricks_cluster = Variable.get("Databricks_Cluster", default_var="0122-181649-acgbmlbq")

# predefined buckets
airflow_dags_bucket_name = f"sfly-aws-dwh-lifetouch-{v_environment}{region_code}lifetouch-mwaa-v1"
artifacts_bucket_name = f"sfly-aws-dwh-lifetouch-{v_environment}{region_code}glue-artifacts"
logs_bucket_name = f"sfly-aws-dwh-lifetouch-{v_environment}{region_code}access-logs"
datalake_bronze_zone = f"sfly-aws-dwh-lifetouch-{v_environment}{region_code}bronze-ingress"
scripts_bucket_name = f"sfly-aws-dwh-lifetouch-{v_environment}{region_code}databricks-scripts"



# predefined roles
glue_role_name = f"sfly-aws-dwh-lifetouch-{v_environment}-svc-glue-role"

# predefined network connection
lt_aws_region = aws_region.replace("-", "_")
glue_network_connection = f"lt_connection_{lt_aws_region}a"

# predefined DB connection
databrick_connection = Variable.get("DATABRICK_CONNECTION_ID", default_var="databricks")
time_zone = pytz.timezone(Variable.get("TIME_ZONE", default_var="US/Central"))
redshift_connection = Variable.get("REDSHIFT_CONNECTION_ID", default_var=f"redshift_{v_country}_connection")
oracle_tdw_connection = Variable.get("PDW_CONNECTION_ID", default_var="oracle_tdw")
lib_name = Variable.get("LIFETOUCH_LIB_NAME", default_var="lifetouch_lib-0.1.8-py3-none-any.whl")
ssh_connection = Variable.get("SSH_CONNECTION", default_var="batch_ingestion")

# sns_toptic
sns_topic_arn = Variable.get("sns_mwaa_notification_topic_arn")

# sns topic for monitoring
# sns_mwaa_notification_topic_arn = Variable.get("sns_mwaa_notification_topic_arn")

# predefined DynamoDB table
watermark_table_name = f'sfly-aws-dwh-lifetouch-{v_environment}-dl-to-dwh-tracking'
metadata_table_name = f'sfly-aws-dwh-lifetouch-{v_environment}-source-metadata-control'

v_src_sql_where = "where modified_date >= DATE_ADD('<LastRunDate>', INTERVAL - 30 MINUTE)"

list_of_stataments = ["drop table", "create table", "create index"]

# predefined tags
dag_tags = {
    "App": "Analytics",
    "DataClassification": 'LifetouchDatasets',
    "BusinessUnit": "Lifetouch",
    "Owner": 'DWH',
    "ManagedBy": 'DataPlatformOperations',
    "Provisioner": 'Airflow'
}

# DAGs general args
default_args = {
    "owner": "lifetouch",
    "start_date": datetime(2024, 2, 13),
    "catchup": False,
    "retries": v_retries,
    "retry_delay": v_retry_delay,
    "email_on_failure": False,
    "email_on_retry": False,
    "weight_rule": "upstream",
}

v_skip_merge = False



if v_environment  in ['dev', 'prod']:
    airflow_dags_bucket_name =  f"sfly-aws-dwh-lifetouch-{v_environment}{region_code}lifetouch-mwaa-v1"
    datalake_bronze_zone = f"sfly-aws-dwh-lifetouch-{v_environment}{region_code}bronze-ingress"
elif v_environment  in ['qa', 'preprod']:
    airflow_dags_bucket_name =  f"sfly-aws-dwh-lifetouch-prod-{v_environment}{region_code}lifetouch-mwaa-v1"
    datalake_bronze_zone = f"sfly-aws-dwh-lifetouch-prod-{v_environment}{region_code}bronze-ingress"


def _key_exists(bucket, key):
    s3 = boto3.client("s3")
    try:
        s3.head_object(Bucket=bucket, Key=key)
        return True
    except botocore.exceptions.ClientError as e:
        if e.response["Error"]["Code"] == "404":
            print(f"Key: '{key}' does not exist!")
            return False
        else:
            print("Something else went wrong")
            raise


def _read_pipeline_config(pipeline_config_file):
    """
       Load Pipeline Package Configuration Yaml File
       :param pipeline_config_file:  package configuration S3 object key relative to MWAA DAG folder
       :return package config dictionary object

    """
    s3_client = boto3.client('s3')
    file_key = f"mwaa/dags/config/{pipeline_config_file}"
    if 'qa' in v_environment:
        env = 'qa'
    else:
        env = v_environment
    region_file_key = file_key.replace(".yaml", f"_{env}.yaml").replace(".yml", f"_{env}.yml")
    print(region_file_key)
    if _key_exists(airflow_dags_bucket_name,
                   region_file_key):
        print(f"Region Config file will be loaded {region_file_key}")
        file_key = region_file_key
    response = s3_client.get_object(Bucket=airflow_dags_bucket_name,
                                    Key=file_key)
    data = yaml.safe_load(response['Body'])
    return data["pipeline"]


def _create_databricks_job_cluster(job_cluster_key, cluster_config_file):
    s3_client = boto3.client('s3')
    file_key = f"mwaa/dags/config/{cluster_config_file}"
    response = s3_client.get_object(Bucket=airflow_dags_bucket_name, Key=file_key)
    _json_content = response['Body'].read().decode('utf-8')
    _cluster_config = json.loads(_json_content)
    _job_clusters = [
        {
            "job_cluster_key": job_cluster_key,
            "new_cluster": _cluster_config
        },
    ]
    return _job_clusters


def _get_databricks_cluster_config(cluster_def_file):
    """
        Load Databricks Cluster Definition JSON File
       :return cluster config dictionary object
    """
    s3_client = boto3.client('s3')
    if cluster_def_file is None:
        cluster_config_file = f"databricks-cluster-{v_environment}-{aws_region}.json"
    else:
        cluster_config_file = cluster_def_file

    file_key = f"mwaa/dags/config/{cluster_config_file}"
    response = s3_client.get_object(Bucket=airflow_dags_bucket_name, Key=file_key)
    json_content = response['Body'].read().decode('utf-8')
    _cluster_config = json.loads(json_content)
    return _cluster_config


def get_secret(secret_name):
    region_name = boto3.client('s3').meta.region_name

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        # For a list of exceptions thrown, see
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise e
    secret = json.loads(get_secret_value_response['SecretString'])
    return secret


# task types corresponding to a DAG operator
LT_TASK_TYPES = {
    "glue-pyspark": lambda dag, task_config, kwargs: create_glue_task(dag, task_config, **kwargs),
    "notebook": lambda dag, task_config, kwargs: create_notebook_task(dag, task_config, **kwargs),
    "spark": lambda dag, task_config, kwargs: create_notebook_task(dag, task_config, **kwargs),
    "sql": lambda dag, task_config, kwargs: create_sql_task(dag, task_config, **kwargs),
    "oracle_script": lambda dag, task_config, kwargs: create_oracle_task(dag, task_config)
}


def create_glue_task(dag: DAG, task_config: dict, **kwargs: dict):
    """
        Create GlueJobOperator task based on task_config
        :param dag:  container DAG that the task belongs to
       :param task_config:  task configuration object defined in config file
       :param kwargs:  Airflow Context argument
       :return GlueJobOperator task
    """
    task_id = f"{task_config['name']}"
    job_name = f"lt_{task_id}"
    script_object_key = task_config['script_location']
    script_location = f"s3://{artifacts_bucket_name}/{script_object_key}"
    dependencies_path = f"confuse,s3://{artifacts_bucket_name}/libraries/{lib_name}"
    dpu_count = task_config['args']['dpu_count']
    worker_type = task_config['args']['worker_type']
    data_source = str(kwargs['package_config']['sources'])
    job_args = {
        # "--extra-py-files": dependencies_path,
        "--additional-python-modules": dependencies_path,
        "--enable-auto-scaling": "true",
        "--output_format": "parquet",
        "--datalake_bucket": f"{datalake_bronze_zone}",
        "--data_source": data_source,
        "--enable-metrics": "true",
        "--enable-job-insights": "true",
        '--enable-spark-ui': 'true',
        '--enable-spark-ui-legacy-path': 'true',
        '--enable-continuous-cloudwatch-log': 'true',
        '--spark-event-logs-path': f"s3://sfly-aws-dwh-lifetouch-{v_environment}-glue-spark-logs/spark_ui/",
        "--conf": "spark.sql.legacy.parquet.int96RebaseModeInRead=CORRECTED --conf spark.sql.legacy.parquet.int96RebaseModeInWrite=CORRECTED --conf spark.sql.legacy.parquet.datetimeRebaseModeInRead=CORRECTED --conf spark.sql.legacy.parquet.datetimeRebaseModeInWrite=CORRECTED"
    }

    _glue_job_task = GlueJobOperator(
        task_id=task_id,
        job_name=job_name,
        region_name=aws_region,
        script_location=script_location,
        iam_role_name=glue_role_name,
        s3_bucket=artifacts_bucket_name,
        script_args=job_args,
        create_job_kwargs={
            "GlueVersion": "4.0",
            "NumberOfWorkers": dpu_count,
            "WorkerType": worker_type,
            "DefaultArguments": job_args,
            "Connections": {"Connections": [glue_network_connection]},
            "Tags": dag_tags
        },
        dag=dag,
    )
    return _glue_job_task


def create_notebook_task(dag: DAG, task_config: dict, **kwargs: dict):
    """
        Create DatabricksSubmitRunOperator task based on task_config
        :param dag:  container DAG that the task belongs to
       :param task_config:  task configuration object defined in config file
       :param kwargs:  Airflow Context argument
       :return DatabricksSubmitRunOperator task
    """
    task_id = task_config['name']
    task_args = task_config['args']
    create_new_cluster = task_args['new_cluster']
    cluster_def_file = task_args.get('cluster_config_file')
    dependencies = task_args['dependencies']
    data_sources = str(kwargs['package_config']['sources'])
    notebook_default_params = {
        "databricks_conn_id": "databricks",
        "run_name": f"run_notebook_{task_id}",
        "libraries": [
            {"jar": f"s3://{scripts_bucket_name}/drivers/ojdbc8.jar"},
            {"jar": f"s3://{scripts_bucket_name}/drivers/mysql-connector-java-8.0.17.jar"},
            {"whl": f"s3://{scripts_bucket_name}/libs/{dependencies}"}
        ]
    }

    if create_new_cluster:
        notebook_default_params['new_cluster'] = _get_databricks_cluster_config(cluster_def_file)
    # else:
    #     notebook_default_params['existing_cluster_id'] = v_databricks_cluster

    base_notebook_params = {'package_config': data_sources,
                            'run_datetime': '{{ ts }}',
                            'last_success_datetime': '{{ prev_data_interval_end_success }}',
                            }

    overlapped_window = task_args.get('overlapped_window')
    if overlapped_window is not None:
        base_notebook_params['overlapped_window'] = overlapped_window

    has_targets = task_args.get('set_target')
    if has_targets is True:
        base_notebook_params['targets'] = str(kwargs['package_config']['targets'])

    notebook_task_params = {
        "notebook_path": f"{task_config['script_location']}",
        "base_parameters": base_notebook_params
    }

    change_type = task_args.get('change_type')
    if change_type == 'delete':
        base_notebook_params['change_type'] = change_type

    _notebook_task = DatabricksSubmitRunOperator(
        task_id=task_id,
        databricks_conn_id=databrick_connection,
        notebook_task=notebook_task_params,
        json=notebook_default_params,
        dag=dag,
        do_xcom_push=True
    )
    return _notebook_task


def create_sql_task(dag: DAG, task_config: dict, **kwargs: dict):
    """
        Create SQLExecuteQueryOperator task based on task_config
        :param dag:  container DAG that the task belongs to
       :param task_config:  task configuration object defined in config file
       :param kwargs:  Airflow Context argument
       :return SQLExecuteQueryOperator task
    """
    task_id = task_config['name']
    sql_script = task_config['script_location']
    split_statements = task_config['split_statements']
    connection_id = task_config['connection_id']
    sql_params = task_config['args']
    _sql_script_task = SQLExecuteQueryOperator(
        task_id=task_id,
        conn_id=connection_id,
        sql=sql_script,
        parameters=sql_params,
        autocommit=True,
        split_statements=split_statements,
        return_last=True,
        show_return_value_in_logs=True,
        dag=dag,
    )
    return _sql_script_task


def create_oracle_task(dag: DAG, session_no: int, task_config: dict, connection_id = oracle_tdw_connection):
    """
    Create OracleSQLQueryOperator task based on task_config.
    
    This function handles the execution of pre-SQL statements at both the task level and task group level.
    
    :param dag: The DAG to which this task belongs.
    :param session_no: Unique session number for the task.
    :param task_config: Dictionary containing the task configuration.
    :return: An instance of OracleSQLQueryOperator.
    """
    task_id = task_config['name']
    sql_script = task_config['script_location']
    sql_params = task_config.get('args', {})
    pre_sql = task_config.get('pre_sql', None)  # Use task-specific pre_sql or fallback to None
    trigger_rule = task_config.get('trigger_rule', 'all_success')
    
    # Create and execute OracleSQLQueryOperator task with pre_sql if provided
    return OracleSQLQueryOperator(
        task_id=task_id,
        conn_id=connection_id,
        sql=sql_script,
        parameters=sql_params,
        split_statements=True,
        dag=dag,
        autocommit=True,
        session_no=session_no,
        pre_sql=pre_sql,  # Execute pre_sql before the main SQL if it's defined
        trigger_rule=trigger_rule,
        time_zone=time_zone
    )



def create_dag_task(dag: DAG, task_config: dict, package_config: dict):
    """
        Create a dag task based on task type in task_config
       :param dag:  container DAG that the task belongs to
       :param task_config:  task configuration object defined in config file
       :param package_config: package source, target configuration
       :return Airflow Dag task
    """
    task_type = task_config['type']
    kwargs_dict = {"package_config": package_config}
    _dag_task = LT_TASK_TYPES.get(task_type)(dag, task_config, kwargs_dict)
    return _dag_task


def _check_next_run(**kwargs):
    dag_id = kwargs['dag'].dag_id
    execution_date = kwargs['execution_date']
    delay_time_minutes = kwargs['delay_time']
    session = settings.Session()
    # Query for the last run before the current one
    prev_dag_run = session.query(DagRun).filter(
        and_(
            DagRun.dag_id == dag_id,
            DagRun.execution_date < execution_date
        )
    ).order_by(DagRun.execution_date.desc()).first()
    session.close()

    if delay_time_minutes == 0:
        return True

    if prev_dag_run:
        if prev_dag_run.end_date:
            previous_end_date = prev_dag_run.end_date.replace(tzinfo=None)
            current_time = datetime.now()
            next_run_time = previous_end_date + timedelta(minutes=delay_time_minutes)
            print(
                f"current_time = {current_time} ,  previous_end_date = {previous_end_date} , next_run_time = {next_run_time} ")
            current_time_minutes = int(current_time.timestamp() / 60)
            next_runtime_minutes = int(next_run_time.timestamp() / 60)
            print(f"current_time minutes = {current_time_minutes} ,  next_runtime_minutes = {next_runtime_minutes}  ")
            print(f"remaining time in minutes = {next_runtime_minutes - current_time_minutes}")
            if (current_time_minutes - next_runtime_minutes) >= 0:
                return True
    else:
        print("No previous successful DAG run found.")
        return True


def create_delay_sensor(delay_time=60, wait_interval=300):
    _shfly_delay_sensor = PythonSensor(
        task_id='SHFLY_Time_Delay',
        python_callable=_check_next_run,
        op_kwargs={
            'delay_time': delay_time,
        },
        timeout=7200,
        # Maximum time in seconds that the sensor will wait for the condition to be true. For example, 10 minutes.
        poke_interval=wait_interval,  # Time in seconds that the sensor waits between each check of the condition.
        mode='poke',  # Other option is 'poke' or 'reschedule',
        soft_fail=True
    )

    return _shfly_delay_sensor


def _is_empty_data(task_config: dict, package_config: dict, **context: dict):
    return False


def create_short_circuit_task(dag: DAG, task_config: dict, package_config: dict):
    """
        Short Circuit Operator
       :param dag:  container DAG that the task belongs to
       :param task_config:  task configuration object defined in config file
       :param kwargs:  Airflow Context argument
       :return ShortCircuitOperator DAG Operator
    """
    task_name = task_config['name']
    shortcircuit_task = ShortCircuitOperator(
        task_id=task_name,
        ignore_downstream_trigger_rules=False,
        python_callable=_is_empty_data,
        provide_context=True,
        op_kwargs={
            'task_config': task_config,
            'package_config': package_config,
        },
        dag=dag,
    )
    return shortcircuit_task


def generate_subpackage_dag(dag_id, subpackage_config_file):
    dag_pipeline_config = _read_pipeline_config(subpackage_config_file)
    package_config = dag_pipeline_config['package']
    task_list = dag_pipeline_config['tasks']
    tasks_count = len(task_list)
    dag_tasks = []

    with DAG(
            dag_id=dag_id,
            default_args=default_args,
            schedule_interval=None,
            description=dag_pipeline_config['description'],
            tags=dag_pipeline_config['tags'],
    ) as subpackage_dag:

        for idx in range(tasks_count):
            dag_task = create_dag_task(subpackage_dag, task_list[idx], package_config)
            dag_tasks.append(dag_task)

        for i in range(tasks_count):
            dag_tasks[i] >> dag_tasks[i + 1]

    return subpackage_dag


import pytz


def check_full_load(dag):
    dag_id = dag.dag_id
    current_date = datetime.now(pytz.utc)
    session = settings.Session()
    # Query for the last run before the current one
    dag_run_result = session.query(DagRun).filter(
        and_(
            DagRun.dag_id == dag_id,
            DagRun.execution_date < current_date
        )
    ).order_by(DagRun.execution_date.desc()).first()
    session.close()

    print(f"dag_run_result = {dag_run_result}")
    if dag_run_result is None:
        return True
    else:
        return False


def log_start_pipeline(dag):
    sql = f"""
            INSERT INTO ODS_OWN.AIRFLOW_PACKAGESTATS
                            (
                                  process_name
                                , schema_name
                                , table_name
                                , step
                                , dag_id
                                , cdc_completion_date
                            )
                            VALUES
                            (
                                  :process_name -- process_name
                                , ' ' -- schema_name
                                , ' ' -- table_name
                                , 'Cntrl' -- step
                                , :dag_id -- dag_id
                                , :cdc_completion_date -- cdc_completion_date
                            )"""

    task_config = {}
    task_config['name'] = f"log_{dag.dag_id}_start_task"
    task_config['script_location'] = sql
    task_config['split_statements'] = False
    task_config['connection_id'] = oracle_tdw_connection
    cdc_completion_date = datetime.now(time_zone).replace(tzinfo=None)
    task_config['args'] = dict(process_name=dag.dag_id, dag_id=dag.dag_id,
                               cdc_completion_date=cdc_completion_date)
    return create_sql_task(dag, task_config)


def log_end_pipeline(dag):
    sql = f"""
        UPDATE ODS_OWN.AIRFLOW_PACKAGESTATS
        SET
            COMPLETION_TIMESTAMP = SYSDATE
        WHERE PACKAGE_STATS_SK =
            (
                SELECT MAX(PACKAGE_STATS_SK) 
                FROM ODS_OWN.AIRFLOW_PACKAGESTATS
                WHERE PROCESS_NAME = :process_name
                    AND STEP = 'Cntrl' 
                    AND completion_timestamp IS NULL
            )
            and 0 = :skip_merge 
            """

    task_config = {}
    task_config['name'] = f"log_{dag.dag_id}_end_task"
    task_config['script_location'] = sql
    task_config['split_statements'] = False
    task_config['connection_id'] = oracle_tdw_connection
    task_config['args'] = dict(process_name=dag.dag_id, skip_merge=1 if v_skip_merge else 0)
    return create_sql_task(dag, task_config)


def _delete_key(d, keys):
    for key in keys:
        if key in d:
            d.pop(key)


def _validate_data_ingestion_params(args, type):
    print(f"validate params for data source type {type} and {args}")
    must_have_keys = ['data_source_type', 'data_source_name', 'source_table', 'dest_schema']
    if type == "oracle":
        must_have_keys.extend(
            ['dest_table', 'tmp_create', 'extract_query', 'v_cdc_load_table_name'])
    elif type == "mysql":
        must_have_keys.extend(
            ['src_schema', 'stg_schema', 'watermark_interval', 'watermark_column'])
    elif type == "mssql":
        must_have_keys.extend(
            ['dest_table', 'tmp_create', 'extract_query'])

    existing_keys = list(set(args.keys()) & set(must_have_keys))
    missing_keys = list(set(must_have_keys) - set(args.keys()))
    print(existing_keys)
    print(missing_keys)
    # check supported data source type
    if type not in ('mysql', 'oracle', 'postgresql', 'mssql'):
        raise Exception(f"Please you have a {type} data source which is not supported yet.")
    # check passed parameters
    if len(missing_keys) > 0:
        raise Exception(
            f"Please fix the missing params, you have {type} data source and you are missing the following fields: {missing_keys}.")


def create_ingestion_params(data_source, entity):
    args = {'data_source_type': data_source['type'], 'data_source_name': data_source['name']}
    args.update(data_source['default_args'])
    args.update(entity)
    args['source_table'] = args.pop('src_table')
    if 'stage_schema' in args:
        args['stg_schema'] = args.pop('stage_schema')
    _delete_key(args, ['unique_keys', 'post_sql', 'pre_sql'])
    if 'excluded_columns' in args:
        excluded_columns = args['excluded_columns'].replace("'", '\"')
        print(f"excluded_columns = {excluded_columns}")
        args['excluded_columns'] = excluded_columns
    _validate_data_ingestion_params(args, data_source['type'])
    return args


def create_merge_task(dag, data_source, entity):
    _default_args = data_source['default_args']
    default_dest_schema = _default_args['dest_schema']
    default_stg_schema = _default_args['stage_schema']
    default_src_prefix = _default_args['src_prefix']
    default_post_sql = _default_args['post_sql'] if 'post_sql' in _default_args else None
    default_pre_sql = _default_args['pre_sql'] if 'pre_sql' in _default_args else None
    default_operations_to_apply = _default_args[
        'operations_to_apply'] if 'operations_to_apply' in _default_args else 'Insert,Update'
    entity_name = entity['src_table']
    dest_schema = entity.get('dest_schema') if entity.get('dest_schema') is not None else default_dest_schema
    stg_schema = entity.get('stage_schema') if entity.get('stage_schema') is not None else default_stg_schema
    post_sql = entity.get('post_sql') if entity.get('post_sql') is not None else default_post_sql
    pre_sql = entity.get('pre_sql') if entity.get('pre_sql') is not None else default_pre_sql
    operations_to_apply = entity.get('operations_to_apply') if entity.get(
        'operations_to_apply') is not None else default_operations_to_apply
    src_prefix = entity.get('src_prefix') if entity.get('src_prefix') is not None else default_src_prefix
    dest_prefix = _default_args['dest_prefix']
    default_excluded_columns = _default_args['excluded_columns']
    default_insert_date_columns = _default_args['insert_date_columns']
    default_update_date_columns = _default_args['update_date_columns']
    default_unique_keys = _default_args['unique_keys']
    excluded_columns = entity.get('excluded_columns') if entity.get(
        'excluded_columns') is not None else default_excluded_columns
    unique_keys_str = entity.get('unique_keys') if entity.get(
        'unique_keys') is not None else default_unique_keys
    insert_date_columns_str = entity.get('insert_date_columns') if entity.get(
        'insert_date_columns') is not None else default_insert_date_columns
    update_date_columns_str = entity.get('update_date_columns') if entity.get(
        'update_date_columns') is not None else default_update_date_columns
    insert_date_columns = [f'{col.strip()}' for col in insert_date_columns_str.split(',')]
    update_date_columns = [f'{col.strip()}' for col in update_date_columns_str.split(',')]
    unique_keys = unique_keys_str.split(',') if isinstance(unique_keys_str, str) else unique_keys_str

    if 'lnd_table' in entity and entity['lnd_table'] is not None and entity['lnd_table'] != "null":
        table = entity['lnd_table']
        src_table_name = f'{dest_schema}.{src_prefix}_{table.upper()}_LND'
    else:
        src_table_name = f'{dest_schema}.{src_prefix}_{entity_name.upper()}_LND'

    if 'target_table' in entity and entity['target_table'] is not None and entity['target_table'] != "null":
        table = entity['target_table']
        src_table_name = f'{dest_schema}.{src_prefix}_{table.upper()}_LND'
        dest_table_name = f'{stg_schema}.{dest_prefix}_{table.upper()}_STG'
    else:
        dest_table_name = f'{stg_schema}.{dest_prefix}_{entity_name.upper()}_STG'

    task_id = f'merge_{stg_schema}_{entity_name.upper()}_STG'
    
    if entity.get('explicit_params') is not None:
        task_id = entity.get('task_id_merge')
        dest_table_name = entity.get('dest_table_merge')
        src_table_name = entity.get('dest_table')
    
    _merge_task = OracleMergePDWOperator(
        task_id=task_id,
        src_table=src_table_name,
        dest_table=dest_table_name,
        oracle_conn_id=oracle_tdw_connection,
        unique_keys=unique_keys,
        excluded_columns=excluded_columns.replace("'", ""),
        insert_sys_date_columns=insert_date_columns,
        update_sys_date_columns=update_date_columns,
        operations_to_apply=operations_to_apply,
        skip_merge=False,
        post_sql=post_sql,
        pre_sql=pre_sql,
        time_zone=time_zone,
        dag=dag)

    return _merge_task


def ingestion_task_group(dag, task_group_config):
    # src_pool = 'PDW_LANDING'
    # target_pool = 'PDW'

    task_group_name = task_group_config['name']
    shell_script_key = "run_ingestion.sh"
    script_local_path = '/home/ec2-user/ingestion'
    ec2_ssh_connection = ssh_connection  # "batch_ingestion"
    # ingestion_script = task_group_config['ingestion_script']
    full_load = task_group_config['full_load']

    with TaskGroup(task_group_name) as _ingestion_task_group:
        # this task can be considered as part of CICD - deployment stage
        download_command = f"""
                                aws s3 cp s3://{datalake_bronze_zone}/ingestion_scripts/{shell_script_key}  {script_local_path};
                                aws s3 cp s3://{datalake_bronze_zone}/ingestion_scripts/ingestion_files/  {script_local_path} --recursive;
                                chmod +x {script_local_path}/{shell_script_key};
                                dos2unix {script_local_path}/{shell_script_key};
                                ls -lt {script_local_path}
                            """
        deploy_task = SSHOperator(
            task_id=f'deploy_{task_group_name}',
            ssh_conn_id=ec2_ssh_connection,
            command=f"{download_command}",
            conn_timeout=7200,
            cmd_timeout=7200,

        )

        start_log_task = log_start_pipeline(dag)
        # end_task = EmptyOperator(task_id=f'end_{task_group_name}', dag=dag)
        end_log_task = log_end_pipeline(dag)

        deploy_task >> start_log_task

        # ingestion for each entity in each data source
        data_sources = task_group_config['data_sources']
        for data_source in data_sources:
            default_merge_required = data_source['default_args']['merge_required']
            entities = data_source['entities']
            for entity in entities:
                entity_name = entity['src_table']
                ingestion_params = create_ingestion_params(data_source, entity)
                ingestion_params['env'] = v_environment if 'qa' not in v_environment else v_environment.split("-")[1]
                ingestion_params['dag_id'] = dag.dag_id
                ingestion_params['full_load'] = str(entity['full_load']) if 'full_load' in entity else str(full_load)
                ingestion_params['aws_region'] = aws_region
                ingestion_params_json = json.dumps(ingestion_params)
                print(f" Ingestion Params  = {ingestion_params_json} ")

                                
                if ingestion_params.get('explicit_params') is not None:
                    task_id = entity.get('task_id')
                else:
                    task_id = f'load_{entity_name.upper()}'
                run_script_command = f"sh {script_local_path}/{shell_script_key} '{ingestion_params_json}';"

                # Execute Python script on EC2 instance  
                landing_task = SSHOperator(
                    task_id= task_id,
                    ssh_conn_id=ec2_ssh_connection,
                    command=run_script_command,
                    conn_timeout=7200,
                    cmd_timeout=7200
                )

                start_log_task >> landing_task

                merge_required = entity.get('merge_required') if entity.get(
                    'merge_required') is not None else default_merge_required
                if merge_required == True:
                    merge_task = create_merge_task(dag, data_source, entity)
                    landing_task >> merge_task
                    merge_task >> end_log_task
                else:
                    landing_task >> end_log_task

    return _ingestion_task_group


def get_task_name(file_path):
    """
    Extracts the file name without extension from a given file path.

    Args:
        file_path (str): The full path to the file.

    Returns:
        str: The file name without the extension.
    """
    # Get the base name of the file from the given file path
    file_name = os.path.basename(file_path)

    # Split the file name and extension, and take only the file name
    file_name_without_extension = os.path.splitext(file_name)[0]

    # Return the file name without the extension
    return file_name_without_extension


def get_transformation_task(dag, task_params, task_pre_sql={},
                            session_no=int(datetime.now(time_zone).timestamp() * 1000),
                            task_default_args={}):
    """
    Creates a transformation task, applying pre_sql at the task level if provided,
    otherwise falling back to task group level pre_sql.
    
    :param dag: The DAG to which this task belongs.
    :param task_params: Dictionary containing the task configuration.
    :param task_pre_sql: Default pre_sql at the task group level.
    :param session_no: Unique session number for the task.
    :param task_default_args: Default arguments applied to the task.
    :return: A DAG task instance.
    """
    # Set the task name based on the script location
    task_id = task_params.get('name', get_task_name(task_params['script_location']))
    task_params['name'] = task_id
    env_default = v_environment if 'qa' not in v_environment else v_environment.split("-")[1]
    env = task_default_args.get('v_env', env_default)
    connection_id = task_default_args.get('connection_id', oracle_tdw_connection)
    # Set the environment variable, making it uppercase
    task_params.setdefault('args', {})['v_env'] = env.upper()

    # Assign pre_sql from task group configuration to the task if not provided
    task_params['pre_sql'] = task_params.get('pre_sql', task_pre_sql)

    # Merge default arguments and specific task arguments
    task_params['args'] = {**task_default_args, **task_params['args']}

    # Create and return the Oracle task
    return create_oracle_task(dag, session_no, task_params, connection_id)




def transformation_task_group(dag, task_group_config):
    # Extract task group configuration
    task_group_name = task_group_config.get('name')
    task_pre_sql = task_group_config.get('pre_sql', {})
    task_default_args = task_group_config.get('default_args', {})
    task_list = task_group_config.get('tasks', [])
    session_no = int(datetime.now(time_zone).timestamp() * 1000)
    logging.info(f"session_no: {session_no}")

    # Create a task group context
    with TaskGroup(task_group_name) as _transformation_task_group:

        dag_tasks = [
            get_transformation_task(dag, task_params, task_pre_sql=task_pre_sql, session_no=session_no,
                                    task_default_args=task_default_args)
            for task_params in task_list
        ]

        # Set up task dependencies to ensure tasks are executed sequentially
        for i in range(len(dag_tasks) - 1):
            dag_tasks[i] >> dag_tasks[i + 1]

    return _transformation_task_group


def on_failure_callback(context):
    env = v_environment if 'qa' not in v_environment else v_environment.split("-")[1]
    try:
        sns_client = boto3.client('sns')
        error_message = str(context.get('exception', 'No error message available'))
        message = {
            "Task Failed": {
                "Dag Id": context['task_instance'].dag_id,
                "Task Id": context['task_instance'].task_id,
                "Execution Date": str(context['execution_date']),
                "Environment": env,
                "Error": error_message
            }
        }
        message_json = json.dumps(message)  
        subject = f"DAG Failure Alert in {env.upper()}: {context['task_instance'].dag_id}"

        response = sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=message_json,
            Subject=subject
        )

        # response = sns_client.publish(TopicArn=sns_topic_arn, Message=message)
        logging.info(f"SNS publish response: {response}")
    except Exception as e:
        logging.error(f"Error in on_failure_callback: {e}")


def on_retry_callback(context):
    env = v_environment if 'qa' not in v_environment else v_environment.split("-")[1]
    try:
        logging.info(f"Context: {context}")

        sns_client = boto3.client('sns')
        error_message = str(context.get('exception', 'No error message available'))
        message = {
            "Task Retry": {
                "Dag Id": context['task_instance'].dag_id,
                "Task Id": context['task_instance'].task_id,
                "Execution Date": str(context['execution_date']),
                "Environment": env,
                "Error": error_message
            }
        }

        message_json = json.dumps(message)  
        subject = f"DAG Retry Alert in {env.upper()}: {context['task_instance'].dag_id}"

        response = sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=message_json,
            Subject=subject
        )
        # response = sns_client.publish(TopicArn=sns_topic_arn, Message=message)
        logging.info(f"SNS publish response: {response}")
    except Exception as e:
        logging.error(f"Error in on_retry_callback: {e}")


def wait_for_data(task_group_config):
    print('task_group_config', task_group_config)
    # Parameters  
    global_rowcount = 1
    # lschema = 'ODS_STAGE'  
    lschema = task_group_config['schema_name']
    pollint = 300000  # milliseconds  
    session_name = task_group_config['session_name']
    sqlfilter = f"status = 'READY' and session_name = '{session_name}'"
    timeout = 0  # milliseconds  
    timeout_with_rows_ok = True
    increment_detection = False
    # table_name = 'DATA_EXPORT_TRIGGER'  
    table_name = task_group_config['table_name']
    start_time = time.time()
    oracle = OracleHook(oracle_conn_id=oracle_tdw_connection)
    conn = oracle.get_conn()
    while True:
        cursor = conn.cursor()
        query = f"SELECT COUNT(*) FROM {lschema}.{table_name} WHERE {sqlfilter}"
        cursor.execute(query)
        row_count, = cursor.fetchone()

        print(f"Checked row count: {row_count} (Condition: {global_rowcount})")

        if row_count >= global_rowcount:
            print(f"Row count condition met: {row_count} rows found.")
            break

        elapsed_time = (time.time() - start_time) * 1000  # convert to milliseconds  
        print(f"Elapsed time: {elapsed_time} ms (Timeout: {timeout} ms)")

        if timeout > 0 and elapsed_time > timeout:
            if timeout_with_rows_ok and row_count > 0:
                print(f"Timeout reached with rows present: {row_count} rows found.")
                break
            else:
                print("Timeout reached without meeting the row count condition.")
                break

        print(f"Polling... No rows meeting the condition yet. Waiting for {pollint / 1000} seconds.")
        time.sleep(pollint / 1000)  # poll interval in seconds  

    cursor.close()
    conn.close()


def wait_for_data_task_group(dag, task_group_config):
    return PythonOperator(
        task_id=f"{task_group_config['name']}",
        python_callable=wait_for_data,
        op_kwargs={'task_group_config': task_group_config},
        dag=dag,
    )


def create_ec2_ssh(task_id, download_command, trigger_rule="all_success"):
    return SSHOperator(
        task_id=task_id,
        ssh_conn_id=ssh_connection,
        command=download_command,
        trigger_rule = trigger_rule,
        conn_timeout=7200,
        cmd_timeout=7200,
    )


def export_data_to_s3(dag, task_group_config):
    ec2_ssh_connection = ssh_connection  # "batch_ingestion"  
    script_local_path = '/home/ec2-user/ingestion'
    shell_script_key = 'export_run_ingestion.sh'
    task_group_name = task_group_config.get('name', 'export_data_to_s3')
    trigger_rule = task_group_config.get('trigger_rule','all_success')
    with TaskGroup(task_group_name, dag=dag) as export_data_to_s3_group:
        download_command = f"""  
            aws s3 cp s3://{datalake_bronze_zone}/ingestion_scripts/{shell_script_key} {script_local_path};  
            aws s3 cp s3://{datalake_bronze_zone}/ingestion_scripts/ingestion_files/ {script_local_path} --recursive;  
            chmod +x {script_local_path}/{shell_script_key};  
            ls -lt {script_local_path}  
        """
        deploy_task = create_ec2_ssh('deploy_export_files', download_command, trigger_rule)

        previous_task = deploy_task

        for i, task in enumerate(task_group_config['tasks'], start=1):
            export_files = task['export_files']
            # export_files = task['export_files']
            # if 'export_files' in task:
            drop_and_create_task = None

            if 'script_location' in task:
                args = {
                    'v_env': (v_environment if 'qa' not in v_environment else v_environment.split("-")[1]).upper()
                }
                if 'args' in task:
                    args.update(task['args'])
                drop_and_create_params = {
                    'name': get_task_name(task['script_location']),
                    'script_location': task['script_location'],
                    'args': args,
                    'pre_sql': task_group_config.get('pre_sql', {})
                }
                print('drop_and_create_params', drop_and_create_params)

                session_no = int(datetime.now(time_zone).timestamp() * 1000)
                drop_and_create_task = create_oracle_task(dag, session_no, drop_and_create_params)
                previous_task >> drop_and_create_task
                previous_task = drop_and_create_task

            extract_tasks = []
            for i, export in enumerate(export_files, start=1):
                export_params = {
                    'env': v_environment if 'qa' not in v_environment else v_environment.split("-")[1],
                    'extract_file_name': export.get('extract_file_name', None),
                    'export_file_name': task_group_config.get('export_file_name', {}),
                    'extract_query': export.get('extract_query', None),
                    'email_configurations': task.get('email_configurations', None),
                    'export_location': export.get('export_location', None),
                    'file_ext': export.get('file_ext', None),
                    'extract_args': export.get('extract_args', None),
                    'file_name_args': export.get('file_name_args', None),
                    'aws_region': aws_region,
                    'export_args': task_group_config.get('export_args', {}),
                    'batch_mode': export.get('batch_mode', None),
                }
                export_params_json = json.dumps(export_params)
                run_script_command = f"sh {script_local_path}/{shell_script_key} '{export_params_json}';"
                if task.get('name') is not None:
                    task_id = task.get('name')
                elif task.get('email_configurations') is not None:
                    task_id = f"{export['extract_query'].split('.')[0].split('/')[-1]}_and_send_email"
                else:
                    task_id = f"{export['extract_query'].split('.')[0].split('/')[-1]}"
                landing_task = create_ec2_ssh(task_id, run_script_command, trigger_rule)

                extract_tasks.append(landing_task)
                if drop_and_create_task:
                    drop_and_create_task >> landing_task
                else:
                    previous_task >> landing_task
                previous_task = landing_task

            previous_task = extract_tasks[-1]

    return export_data_to_s3_group


def check_branch_status(task_group_config):
    print("branch task config: ", task_group_config)
    operator_mapping = {
        '>': operator.gt,
        '<': operator.lt,
        '=': operator.eq,
        '!=': operator.ne,
        '>=': operator.ge,
        '<=': operator.le
    }
    conn_id = task_group_config.get('connection_id', oracle_tdw_connection)
    print("connection id: ", conn_id)
    condition_script_path = task_group_config.get('condition_script')
    parameters = task_group_config.get('args',{})
    print("Parameters :",parameters)

    print("path of the sql file on s3: ", condition_script_path)
    # env = v_environment if 'qa' not in v_environment else v_environment.split("-")[1]
    print("environment: ", v_environment)
    bucket_name = f"sfly-aws-dwh-lifetouch-{v_environment}-lifetouch-mwaa-v1"
    condition_query = read_sql_from_s3(bucket_name,
                                       f"mwaa/{condition_script_path}")
    # if any parameters, extract its value, and replace the extraced value with the bind variable in the condition query
    for parameter_key,parameter_script_location in parameters.items():
        parameter_query = read_sql_from_s3(bucket_name,
                                       f"mwaa/{parameter_script_location}")
        
        parameter_value = execute_sql(conn_id, parameter_query)

        if isinstance(parameter_value, str):
            condition_query = re.sub(f":{parameter_key}", f"'{parameter_value}'", condition_query)
        else:
            condition_query = re.sub(f":{parameter_key}", str(parameter_value), condition_query)
    
    print("Final query from S3: ", condition_query)

    condition_result = execute_sql(conn_id, condition_query)

    print("condition result: ", condition_result)
    compared_value = task_group_config.get('compared_value')

    if isinstance(compared_value, str) and compared_value.endswith('.sql'):
        compared_parameter_script = read_sql_from_s3(bucket_name,
                                       f"mwaa/{compared_value}")
        compared_value = execute_sql(conn_id, compared_parameter_script)
    print("compared value: ", compared_value)
    task_ids = task_group_config.get('task_ids')
    print("task_ids: ", task_ids)
    operator_str = task_group_config.get('operator')
    print("operator: ", operator_str)
    logical_operator = operator_mapping[operator_str]
    if logical_operator(condition_result, compared_value):
        print("Condition met, triggering task: ", task_ids['true'])
        return task_ids['true']
    else:
        print("Condition not met, triggering task: ", task_ids['false'])
        return task_ids['false']


def check_branch(dag, task_group_config):
    return BranchPythonOperator(
        task_id=f"{task_group_config['name']}",
        python_callable=check_branch_status,
        op_kwargs={'task_group_config': task_group_config},
        dag=dag,
    )


def send_email(dag, task_group_config):
    ec2_ssh_connection = ssh_connection
    script_local_path = '/home/ec2-user/ingestion'
    shell_script_key = 'send_email.sh'
    task_name = task_group_config['name']
    trigger_rule = task_group_config.get('trigger_rule', 'all_success')
    email_params = {
        'env': v_environment if 'qa' not in v_environment else v_environment.split("-")[1],
        'email_configurations': task_group_config.get('email_configurations', None),
        'message': task_group_config.get('message',None),
    }
    email_params_json = json.dumps(email_params)
    run_script_command = f"sh {script_local_path}/{shell_script_key} '{email_params_json}';"
    send_email_task = create_ec2_ssh(task_name, run_script_command, trigger_rule)
    return send_email_task


def deploy_files():
    script_local_path = '/home/ec2-user/ingestion'
    shell_script_key = 'send_email.sh'
    download_command = f"""  
            aws s3 cp s3://{datalake_bronze_zone}/ingestion_scripts/{shell_script_key} {script_local_path};  
            aws s3 cp s3://{datalake_bronze_zone}/ingestion_scripts/ingestion_files/ {script_local_path} --recursive;  
            chmod +x {script_local_path}/{shell_script_key};
            dos2unix {script_local_path}/{shell_script_key};  
            ls -lt {script_local_path} """
    return create_ec2_ssh("deploy_files", download_command)


def read_sql_from_s3(bucket_name, file_key, aws_region=None):
    """
    Reads a SQL file from an S3 bucket and returns its content as a string.
    :param bucket_name: Name of the S3 bucket
    :param file_key: Key of the file in the S3 bucket
    :param aws_region: AWS region where the S3 bucket is located. If not provided, defaults to the region configured in boto3
    :return: SQL file content as a string
    """
    s3 = boto3.client("s3", region_name=aws_region)
    try:
        response = s3.get_object(Bucket=bucket_name, Key=file_key)
        return response["Body"].read().decode("utf-8")
    except ClientError as e:
        if e.response['Error']['Code'] == 'NoSuchKey':
            print(f"The file {file_key} does not exist in the bucket {bucket_name}.")
            raise e
        else:
            # print(f"Unexpected error occurred: {e}")
            raise e


def execute_sql(oracle_conn_id, sqlcmd):
    print('Executing Sql: ' + str(sqlcmd))
    oracledb.init_oracle_client()
    oracle = OracleHook(oracle_conn_id)
    with closing(oracle.get_conn()) as conn:
        with closing(conn.cursor()) as cursor:
            cursor.execute(sqlcmd)
            cursor.connection.commit()
            return cursor.fetchall()[0][0]

def dummy_end(dag,task_id="end"):
    return EmptyOperator(
        task_id=task_id,
        dag=dag,
    )
    