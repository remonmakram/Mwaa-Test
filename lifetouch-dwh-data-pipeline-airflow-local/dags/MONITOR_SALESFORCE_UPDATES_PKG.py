from airflow import DAG
import lifetouch.commons.pipeline_utils as lt
from datetime import datetime, timedelta

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
dag_config_file = "MONITOR_SALESFORCE_UPDATES_PKG/MONITOR_SALESFORCE_UPDATES_PKG.yaml" 
dag_pipeline_config = lt._read_pipeline_config(dag_config_file)
main_dag_id = dag_pipeline_config['name']
schedule = f"{dag_pipeline_config['schedule']}"
pipeline_tags = dag_pipeline_config['tags']
task_groups = dag_pipeline_config['task_groups']
dag_tasks = []

with DAG(
        dag_id = main_dag_id,
        start_date = datetime(2024, 1, 1),
        catchup = False,
        max_active_runs = 1,
        schedule_interval= schedule,
        tags = pipeline_tags,
) as dag:
    drop_and_create = lt.transformation_task_group(dag, task_group_config=task_groups[0])
    evaluate_branch = lt.check_branch(dag, task_group_config=task_groups[1])
    send_email = lt.send_email(dag, task_group_config=task_groups[2])
    dummy_end = lt.dummy_end(dag)
    transformation_task_group = lt.transformation_task_group(dag, task_groups[3])

    drop_and_create >> evaluate_branch >> [send_email,dummy_end] 

    send_email >>  transformation_task_group


