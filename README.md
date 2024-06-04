# FlightRadar ELT pipeline

## About the project

This project implements an ELT (Extract, Load, Transform) pipeline using the FlightRadar24 API which exposes real-time flights data, airports and airlines data.

## Pipeline architecture

![Pipeline architecture](https://github.com/oli2v/flight-radar-gcp/blob/main/images/elt_pipeline_architecture_diagram.svg)

The pipeline is built in the Google Cloud Platform environment. It makes use of the following services:
- Cloud Storage to store data
- Dataproc to run PySpark jobs
- BigQuery to query data
- Cloud Composer Environment to orchestrate the whole pipeline

The pipeline is materialized by a DAG within a Cloud Composer Environment. The DAG is triggered every 2 hours to run a PySpark job in a Dataproc cluster. The PySpark job runs requests upon FlightRadar24 API (step 2), stores raw data as a timestamped .json file into a Cloud Storage bucket, normalizes raw data, stores them as partitioned .parquet files in the same bucket (step 3) and eventually loads the data into a BigQuery dataset (step 4).

The cloud infrastructure is mainly built with Terraform (step 1) and transformations are performed within dbt Cloud (step 5).

## Usage

To build the pipeline, you can reproduce the following steps:

1. Clone the following repository
2. Go to [Google Cloud Platform Console](https://console.cloud.google.com/) and create a new project
3. Under IAM & Admin > Service Accounts, click on Create service account and give it a name
4. Click on Keys and Add key > Create new key > JSON
5. Download the generated JSON file and place it at the root of this project
6. Under IAM & Admin > IAM, click on the pencil to edit principal and assign the following roles to the service account:
    - Project IAM Admin
    - Service Account Admin
    - Service Account User
    - Storage Admin
    - Composer Administrator
    - Dataproc Administrator
    - Dataproc Worker
    - BigQuery User
6. In the main.tf file, replace "flight-radar-service-account-credentials.json" with the name of your service account credentials file
7. In the locals.tf file, replace project_name, project_id and region with your the project name, project id and region of the project you just created
8. Run the following command `make build`. This step could take a while (about 30 minutes).

The pipeline should now be up and running! 

Search for Composer Environment on the GCP console top bar, then click on `your-project-name-environment`. Under dags, you should be able to see the deployed DAG `your_project_name_dag`. From there, you can select a run and its associated tasks. If a task has failed, you can click on it and analyze the logs.
Since the DAG is composed of one task (a DataprocSubmitJobOperator task), you can also search for Dataproc in the top bar, select the cluster `your-project-name-cluster`, then under Jobs, click on the job that failed and analyze the output.

## Author

[Olivier Valenduc](https://github.com/oli2v)
