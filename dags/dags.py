import os
import datetime

from airflow.models import DAG
from airflow.providers.google.cloud.operators.dataproc import DataprocSubmitJobOperator


WORFKLOW_DAG_ID = "flight_radar_dag"
WORFKFLOW_START_DATE = datetime.date.today()
WORKFLOW_SCHEDULE_INTERVAL = "0 */2 * * *"

WORKFLOW_DEFAULT_ARGS = {
    "owner": "Olivier Valenduc",
    "start_date": WORFKFLOW_START_DATE,
    "retries": 0,
}

PROJECT_ID = os.getenv("PROJECT_ID")
REGION = os.getenv("REGION")
DATAPROC_CLUSTER_NAME = os.getenv("DATAPROC_CLUSTER_NAME")
COMPOSER_BUCKET_NAME = os.getenv("COMPOSER_BUCKET_NAME")

PYSPARK_JOB = {
    "reference": {"project_id": PROJECT_ID},
    "placement": {"cluster_name": DATAPROC_CLUSTER_NAME},
    "pyspark_job": {"main_python_file_uri": f"gs://{COMPOSER_BUCKET_NAME}/dags/run.py"},
}

dag = DAG(
    dag_id=WORFKLOW_DAG_ID,
    schedule_interval=WORKFLOW_SCHEDULE_INTERVAL,
    default_args=WORKFLOW_DEFAULT_ARGS,
    catchup=False,
)


pyspark_task = DataprocSubmitJobOperator(
    task_id="pyspark_task",
    job=PYSPARK_JOB,
    region=REGION,
    project_id=PROJECT_ID,
    dag=dag,
)

pyspark_task
