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
dag_config_file = "99_GL_TRANS_DUMP_MONTHLY_PKG/99_GL_TRANS_DUMP_MONTHLY_PKG.yaml"
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
    

    gl_transformation_1 = lt.transformation_task_group(dag, task_groups[0])
    evaluate_gl = lt.check_branch(dag, task_groups[1])
    send_email_1 = lt.send_email(dag, task_groups[2])
    export_gl = lt.export_data_to_s3(dag, task_group_config=task_groups[3])
    ep_transformation_1 = lt.transformation_task_group(dag, task_groups[4])
    evaluate_ep = lt.check_branch(dag, task_groups[5])
    send_email_2 = lt.send_email(dag, task_groups[6])
    export_ep = lt.export_data_to_s3(dag, task_group_config=task_groups[7])
    yp_transformation_1 = lt.transformation_task_group(dag, task_groups[8])
    evaluate_yp = lt.check_branch(dag, task_groups[9])
    send_email_3 = lt.send_email(dag, task_groups[10])
    export_yp = lt.export_data_to_s3(dag, task_group_config=task_groups[11])
    subpackages_cdc_update = lt.transformation_task_group(dag, task_groups[12])
    gl_transformation_2 = lt.transformation_task_group(dag, task_groups[13])
    # gl_transformation_1 >> evaluate_gl
    gl_transformation_1 >> evaluate_gl >> [export_gl, send_email_1]
    export_gl >> ep_transformation_1 >> evaluate_ep >> [export_ep, send_email_2]
    export_ep >> yp_transformation_1 >>    evaluate_yp >> [export_yp, send_email_3]  
    export_yp >> subpackages_cdc_update >> gl_transformation_2
