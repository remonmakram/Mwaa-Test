from airflow import DAG
import lifetouch.commons.pipeline_utils as lt
from datetime import datetime, timedelta
import logging
import boto3


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


dag_config_file = "99_SFLY_MLT_COUPON_MAIN_PKG/99_sfly_mlt_coupon_main_pipeline_config.yml"
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
    
    full_load = lt.check_full_load(dag)

    task_groups[0]['full_load'] = str(full_load)

    ingestion_task_group = lt.ingestion_task_group(dag, task_groups[0])

    export_data_to_s3 = lt.export_data_to_s3(dag, task_groups[1])

    transformation_task_group = lt.transformation_task_group(dag, task_groups[2])

    send_email_ok = lt.send_email(dag, task_groups[3])

    send_email_not_ok = lt.send_email(dag, task_groups[4])

    ingestion_task_group >> transformation_task_group >> export_data_to_s3 >> send_email_ok >> send_email_not_ok
     


