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
dag_config_file = "MONITOR_PLPS_DATA_ISSUES_PKG/MONITOR_PLPS_DATA_ISSUES_Pipeline_config.yaml"
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
    MONITOR_PLPS_DETAIL_POST_ADDS_UP_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[0])
    MONITOR_PLPS_DETAIL_POST_HEADER_CHILD_DIFF_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[1])
    MONITOR_PLPS_DETAIL_ACT_POS_NOT_X_ORDERS_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[2])
    MONITOR_PLPS_DETAIL_MERCH_POS_NOT_X_ORDERS_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[3])
    MONITOR_PLPS_ACT_POS_NOT_IN_DETAIL_POST_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[4])
    MONITOR_PLPS_MERCH_POS_NOT_IN_DETAIL_POST_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[5])
    MONITOR_PLPS_ORDER_GUID_IN_CLI_NOT_IN_CLH_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[6])
    MONITOR_PLPS_ORDER_GUID_IN_COH_NOT_IN_CLI_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[7])
    MONITOR_PLPS_DIFF_IN_COH_AND_CLI_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[8])
    MONITOR_PLPS_PROMO_CODE_MISSING_REVENUE_SHARE_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[9])
    MONITOR_PLPS_STD_ORG_LOAD_INCORRECT_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[10])
    MONITOR_PLPS_ORDER_CODE_NEW_PROD_CCPRICING_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[11])
    MONITOR_PLPS_DIFF_IN_CCP_ND_DP_NOT_IN_CCP_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[12])
    MONITOR_PLPS_DIFF_IN_CCP_NOT_IN_DETAIL_POS_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[13])
    MONITOR_PLPS_DIFF_IN_CCPRICING_DETAIL_POST_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[14])
    MONITOR_PLPS_ALL_ACT_CHILD_REC_IDF_POS_IDS_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[15])
    MONITOR_PLPS_ALL_MER_CHILD_REC_IDF_POS_IDS_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[16])
    MONITOR_PLPS_CCPLI_IS_NULL_1_PRC = lt.transformation_task_group(dag, task_group_config=task_groups[17])

    check_v_detail_post_adds_up_updates_count = lt.check_branch(dag, task_group_config=task_groups[18])
    check_v_detail_post_header_child_diff_updates_count = lt.check_branch(dag, task_group_config=task_groups[19])
    check_v_detail_act_pos_not_x_orders = lt.check_branch(dag, task_group_config=task_groups[20])
    check_v_detail_merch_pos_not_x_orders_updates_count = lt.check_branch(dag, task_group_config=task_groups[21])
    check_v_act_pos_not_in_detail_post_count = lt.check_branch(dag, task_group_config=task_groups[22])
    check_v_merch_pos_not_in_detail_post_count = lt.check_branch(dag, task_group_config=task_groups[23])
    check_v_order_guid_in_cli_not_in_clh_count = lt.check_branch(dag, task_group_config=task_groups[24])
    check_v_order_guid_in_coh_not_in_cli_count = lt.check_branch(dag, task_group_config=task_groups[25])
    check_v_diff_in_coh_and_cli_count = lt.check_branch(dag, task_group_config=task_groups[26])
    check_v_promo_code_missing_revenue_share_count = lt.check_branch(dag, task_group_config=task_groups[27])
    check_v_std_org_load_incorrect_count = lt.check_branch(dag, task_group_config=task_groups[28])
    check_v_order_code_new_prod_ccpricing_count = lt.check_branch(dag, task_group_config=task_groups[29])
    check_v_diff_in_ccp_nd_dP_not_in_CCP_count = lt.check_branch(dag, task_group_config=task_groups[30])
    check_v_diff_in_ccp_not_in_detail_pos_count = lt.check_branch(dag, task_group_config=task_groups[31])
    check_v_diff_in_ccpricing_detail_post_count = lt.check_branch(dag, task_group_config=task_groups[32])
    check_v_all_act_child_rec_idf_pos_ids_count = lt.check_branch(dag, task_group_config=task_groups[33])
    check_v_all_mer_child_rec_idf_pos_ids_count = lt.check_branch(dag, task_group_config=task_groups[34])
    check_v_sbase_code_is_null_in_ccpli_1_count = lt.check_branch(dag, task_group_config=task_groups[35])

    send_email_1 = lt.send_email(dag, task_group_config=task_groups[36])
    send_email_2 = lt.send_email(dag, task_group_config=task_groups[37])
    send_email_3 = lt.send_email(dag, task_group_config=task_groups[38])
    send_email_4 = lt.send_email(dag, task_group_config=task_groups[39])
    send_email_5 = lt.send_email(dag, task_group_config=task_groups[40])
    send_email_6 = lt.send_email(dag, task_group_config=task_groups[41])
    send_email_7 = lt.send_email(dag, task_group_config=task_groups[42])
    send_email_8 = lt.send_email(dag, task_group_config=task_groups[43])
    send_email_9 = lt.send_email(dag, task_group_config=task_groups[44])
    send_email_10 = lt.send_email(dag, task_group_config=task_groups[45])
    send_email_11 = lt.send_email(dag, task_group_config=task_groups[46])
    send_email_12 = lt.send_email(dag, task_group_config=task_groups[47])
    send_email_13 = lt.send_email(dag, task_group_config=task_groups[48])
    send_email_14 = lt.send_email(dag, task_group_config=task_groups[49])
    send_email_15 = lt.send_email(dag, task_group_config=task_groups[50])
    send_email_16 = lt.send_email(dag, task_group_config=task_groups[51])
    send_email_17 = lt.send_email(dag, task_group_config=task_groups[52])
    send_email_19 = lt.send_email(dag, task_group_config=task_groups[53])
    end = lt.dummy_end(dag)

    MONITOR_PLPS_DETAIL_POST_ADDS_UP_PRC >> check_v_detail_post_adds_up_updates_count >> [send_email_1, MONITOR_PLPS_DETAIL_POST_HEADER_CHILD_DIFF_PRC]
    send_email_1 >> MONITOR_PLPS_DETAIL_POST_HEADER_CHILD_DIFF_PRC
    MONITOR_PLPS_DETAIL_POST_HEADER_CHILD_DIFF_PRC >> check_v_detail_post_header_child_diff_updates_count >> [send_email_2, MONITOR_PLPS_DETAIL_ACT_POS_NOT_X_ORDERS_PRC]
    send_email_2>> MONITOR_PLPS_DETAIL_ACT_POS_NOT_X_ORDERS_PRC
    MONITOR_PLPS_DETAIL_ACT_POS_NOT_X_ORDERS_PRC >> check_v_detail_act_pos_not_x_orders >> [send_email_3, MONITOR_PLPS_DETAIL_MERCH_POS_NOT_X_ORDERS_PRC]
    send_email_3 >> MONITOR_PLPS_DETAIL_MERCH_POS_NOT_X_ORDERS_PRC
    MONITOR_PLPS_DETAIL_MERCH_POS_NOT_X_ORDERS_PRC >> check_v_detail_merch_pos_not_x_orders_updates_count >> [send_email_4, MONITOR_PLPS_ACT_POS_NOT_IN_DETAIL_POST_PRC]
    send_email_4 >> MONITOR_PLPS_ACT_POS_NOT_IN_DETAIL_POST_PRC
    MONITOR_PLPS_ACT_POS_NOT_IN_DETAIL_POST_PRC >> check_v_act_pos_not_in_detail_post_count >> [send_email_5, MONITOR_PLPS_MERCH_POS_NOT_IN_DETAIL_POST_PRC]
    send_email_5 >> MONITOR_PLPS_MERCH_POS_NOT_IN_DETAIL_POST_PRC
    MONITOR_PLPS_MERCH_POS_NOT_IN_DETAIL_POST_PRC >> check_v_merch_pos_not_in_detail_post_count >> [send_email_6, MONITOR_PLPS_ORDER_GUID_IN_CLI_NOT_IN_CLH_PRC]
    send_email_6 >> MONITOR_PLPS_ORDER_GUID_IN_CLI_NOT_IN_CLH_PRC
    MONITOR_PLPS_ORDER_GUID_IN_CLI_NOT_IN_CLH_PRC >> check_v_order_guid_in_cli_not_in_clh_count >> [send_email_7, MONITOR_PLPS_ORDER_GUID_IN_COH_NOT_IN_CLI_PRC]
    send_email_7 >> MONITOR_PLPS_ORDER_GUID_IN_COH_NOT_IN_CLI_PRC
    MONITOR_PLPS_ORDER_GUID_IN_COH_NOT_IN_CLI_PRC >> check_v_order_guid_in_coh_not_in_cli_count >> [send_email_8, MONITOR_PLPS_DIFF_IN_COH_AND_CLI_PRC]
    send_email_8 >> MONITOR_PLPS_DIFF_IN_COH_AND_CLI_PRC
    MONITOR_PLPS_DIFF_IN_COH_AND_CLI_PRC >> check_v_diff_in_coh_and_cli_count >> [send_email_9, MONITOR_PLPS_PROMO_CODE_MISSING_REVENUE_SHARE_PRC]
    send_email_9 >> MONITOR_PLPS_PROMO_CODE_MISSING_REVENUE_SHARE_PRC
    MONITOR_PLPS_PROMO_CODE_MISSING_REVENUE_SHARE_PRC >> check_v_promo_code_missing_revenue_share_count >> [send_email_10, MONITOR_PLPS_STD_ORG_LOAD_INCORRECT_PRC]
    send_email_10 >> MONITOR_PLPS_STD_ORG_LOAD_INCORRECT_PRC
    MONITOR_PLPS_STD_ORG_LOAD_INCORRECT_PRC >> check_v_std_org_load_incorrect_count >> [send_email_11, MONITOR_PLPS_ORDER_CODE_NEW_PROD_CCPRICING_PRC]
    send_email_11 >> MONITOR_PLPS_ORDER_CODE_NEW_PROD_CCPRICING_PRC
    MONITOR_PLPS_ORDER_CODE_NEW_PROD_CCPRICING_PRC >> check_v_order_code_new_prod_ccpricing_count >> [send_email_12, MONITOR_PLPS_DIFF_IN_CCP_ND_DP_NOT_IN_CCP_PRC]
    send_email_12 >> MONITOR_PLPS_DIFF_IN_CCP_ND_DP_NOT_IN_CCP_PRC
    MONITOR_PLPS_DIFF_IN_CCP_ND_DP_NOT_IN_CCP_PRC >> check_v_diff_in_ccp_nd_dP_not_in_CCP_count >> [send_email_13, MONITOR_PLPS_DIFF_IN_CCP_NOT_IN_DETAIL_POS_PRC]
    send_email_13 >> MONITOR_PLPS_DIFF_IN_CCP_NOT_IN_DETAIL_POS_PRC
    MONITOR_PLPS_DIFF_IN_CCP_NOT_IN_DETAIL_POS_PRC >> check_v_diff_in_ccp_not_in_detail_pos_count >> [send_email_14, MONITOR_PLPS_DIFF_IN_CCPRICING_DETAIL_POST_PRC]
    send_email_14 >> MONITOR_PLPS_DIFF_IN_CCPRICING_DETAIL_POST_PRC
    MONITOR_PLPS_DIFF_IN_CCPRICING_DETAIL_POST_PRC >> check_v_diff_in_ccpricing_detail_post_count >> [send_email_15, MONITOR_PLPS_ALL_ACT_CHILD_REC_IDF_POS_IDS_PRC]
    send_email_15 >> MONITOR_PLPS_ALL_ACT_CHILD_REC_IDF_POS_IDS_PRC
    MONITOR_PLPS_ALL_ACT_CHILD_REC_IDF_POS_IDS_PRC >> check_v_all_act_child_rec_idf_pos_ids_count >> [send_email_16, MONITOR_PLPS_ALL_MER_CHILD_REC_IDF_POS_IDS_PRC]
    send_email_16 >> MONITOR_PLPS_ALL_MER_CHILD_REC_IDF_POS_IDS_PRC
    MONITOR_PLPS_ALL_MER_CHILD_REC_IDF_POS_IDS_PRC >> check_v_all_mer_child_rec_idf_pos_ids_count >> [send_email_17,  MONITOR_PLPS_CCPLI_IS_NULL_1_PRC]
    send_email_17 >> MONITOR_PLPS_CCPLI_IS_NULL_1_PRC
    MONITOR_PLPS_CCPLI_IS_NULL_1_PRC >> check_v_sbase_code_is_null_in_ccpli_1_count >> [send_email_19, end]
