#!/bin/bash

# Switch to ec2-user and run the following commands as ec2-user
echo "ingestion params = $1"
pwd
cd ingestion
source env/bin/activate
python3 send_email.py --parameters "$1"
