import argparse
import boto3
from botocore.exceptions import ClientError
from datetime import datetime, timedelta, timezone
from collections.abc import Iterable
from awsglue.utils import getResolvedOptions
import json
import sys
import re

bucket_name=""
s3 = boto3.client('s3')

def create_folders(pkg_name,source_type):

    #Create Config Folder
    s3_key=f"mwaa/dags/config/{pkg_name}/"
    s3.put_object(Bucket=bucket_name, Key=s3_key)
    print(f'Folder "{s3_key}" created in bucket "{bucket_name}".') 

    #Create SQL Folder
    s3_key=f"mwaa/dags/sql/{pkg_name}/"
    s3.put_object(Bucket=bucket_name, Key=s3_key)
    print(f'Folder "{s3_key}" created in bucket "{bucket_name}".') 

    #Create oracle_sqls folder
    if source_type == 'oracle':
        s3_key=f"mwaa/oracle_sqls/{pkg_name}/"
        s3.put_object(Bucket=bucket_name, Key=s3_key)
        print(f'Folder "{s3_key}" created in bucket "{bucket_name}".') 

def create_config_file(pkg_name,source_type):
    content=''
    if source_type =='mysql':
        file_key="mwaa/automation/templates/mysql_config_file_template.yaml"
        response = s3.get_object(Bucket=bucket_name, Key=file_key)  
        content = response['Body'].read().decode('utf-8') 
                
    elif source_type =='oracle':
        file_key="mwaa/automation/templates/oracle_config_file_template.yaml"
        response = s3.get_object(Bucket=bucket_name, Key=file_key)  
        content = response['Body'].read().decode('utf-8') 
        
    elif source_type =='dw':
        file_key="mwaa/automation/templates/dw_config_file_template.yaml"
        response = s3.get_object(Bucket=bucket_name, Key=file_key)  
        content = response['Body'].read().decode('utf-8') 
    elif source_type =='99':
        file_key="mwaa/automation/templates/99_config_file_template.yaml"
        response = s3.get_object(Bucket=bucket_name, Key=file_key)  
        content = response['Body'].read().decode('utf-8') 

    content=content.replace("PKG_NAME",pkg_name)
    file_key= f"mwaa/dags/config/{pkg_name}/{pkg_name}_pipeline_config.yaml"
    s3.put_object(Bucket=bucket_name, Key=file_key, Body=content) 

def create_dag(pkg_name,source_type):
    content=''
    if source_type =='dw':
        file_key="mwaa/automation/templates/dag_template_dw.py"
        response = s3.get_object(Bucket=bucket_name, Key=file_key)  
        content = response['Body'].read().decode('utf-8')
    elif source_type == '99':
        file_key="mwaa/automation/templates/dag_template_99.py"
        response = s3.get_object(Bucket=bucket_name, Key=file_key)  
        content = response['Body'].read().decode('utf-8')
                
    else:
        file_key="mwaa/automation/templates/dag_template.py"
        response = s3.get_object(Bucket=bucket_name, Key=file_key)  
        content = response['Body'].read().decode('utf-8')
        
   
    content=content.replace("PKG_NAME",pkg_name)
    file_key= f"mwaa/dags/{pkg_name}_dag.py"
    s3.put_object(Bucket=bucket_name, Key=file_key, Body=content) 

if __name__ == "__main__":
    args = getResolvedOptions(sys.argv, ["package_name", "source_type","bucket_name"])
    pkg_name=args["package_name"]
    source_type=args["source_type"]
    bucket_name=args["bucket_name"]
    available_sources=['mysql','dw','oracle','99']
    pkg_name=pkg_name.lower()
    source_type=source_type.lower()


    if source_type not in available_sources:
         raise ValueError("Not an available source!") 
    else:
         
        #print(pkg_name)
        create_folders(pkg_name,source_type)
        create_config_file(pkg_name,source_type)
        create_dag(pkg_name,source_type)
