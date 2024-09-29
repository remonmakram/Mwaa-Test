from airflow import DAG
import lifetouch.commons.pipeline_utils as lt
from datetime import datetime, timedelta
import logging
import boto3
from airflow.operators.python_operator import PythonOperator  

# DAGs default args
default_args = {
    'owner': 'lifetouch',
    "start_date": datetime(2024, 2, 13),
    "catchup": False,
    "email_on_failure": False,
    "email_on_retry": False,
    'on_failure_callback': lt.on_failure_callback,  
     'on_retry_callback': lt.on_retry_callback,  
    'retries': 1,  
    'retry_delay': timedelta(minutes=3), 
    "weight_rule": "upstream",
}


# read DAG configuration
dag_config_file = "99_pdk_report_pkg/99_pdk_report_pkg_pipeline_config.yaml"
dag_pipeline_config = lt._read_pipeline_config(dag_config_file)
main_dag_id = dag_pipeline_config['name']
schedule = f"{dag_pipeline_config['schedule']}"
pipeline_tags = dag_pipeline_config['tags']
task_groups = dag_pipeline_config['task_groups']
dag_tasks = []

with DAG(
        default_args=default_args,
        dag_id = main_dag_id,
        start_date = datetime(2023, 1, 1),
        catchup = False,
        max_active_runs = 1,
        schedule_interval= schedule,
        tags = pipeline_tags,
) as dag:
    
    
    export_data_to_s3 = lt.export_data_to_s3(dag, task_group_config=task_groups[0])

    export_data_to_s3
    

