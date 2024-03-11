import datetime

from airflow.models import DAG
from airflow.providers.google.cloud.operators.dataproc import (
    DataprocSubmitJobOperator,
)

WORFKLOW_DAG_ID = "flight_radar_dag"
WORFKFLOW_START_DATE = datetime.datetime(2024, 3, 10)
WORKFLOW_SCHEDULE_INTERVAL = "0 */2 * * *"

WORKFLOW_DEFAULT_ARGS = {
    "owner": "Olivier Valenduc",
    "start_date": WORFKFLOW_START_DATE,
    "retries": 0,
}

dag = DAG(
    dag_id=WORFKLOW_DAG_ID,
    schedule_interval=WORKFLOW_SCHEDULE_INTERVAL,
    default_args=WORKFLOW_DEFAULT_ARGS,
    catchup=False,
)

PROJECT_ID = "flight-radar-415911"
REGION = "europe-west9"
PYSPARK_JOB = {
    "reference": {"project_id": PROJECT_ID},
    "placement": {"cluster_name": "flight-radar-cluster"},
    "pyspark_job": {
        "main_python_file_uri": "gs://europe-west9-flight-radar-c-81396519-bucket/dags/run.py"
    },
}

pyspark_task = DataprocSubmitJobOperator(
    task_id="pyspark_task", job=PYSPARK_JOB, region=REGION, project_id=PROJECT_ID
)

pyspark_task
