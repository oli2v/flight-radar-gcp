#!bin/bash
COMPOSER_BUCKET_NAME=$(/usr/share/google/get_metadata_value attributes/COMPOSER_BUCKET_NAME)
PROJECT_ID=$(/usr/share/google/get_metadata_value attributes/PROJECT_ID)
DATA_BUCKET_NAME=$(/usr/share/google/get_metadata_value attributes/DATA_BUCKET_NAME)
BQ_DATASET_NAME=$(/usr/share/google/get_metadata_value attributes/BQ_DATASET_NAME)

mkdir /etc/environment

echo "PROJECT_ID=${PROJECT_ID}" >> /etc/environment
echo "DATA_BUCKET_NAME=${DATA_BUCKET_NAME}" >> /etc/environment
echo "BQ_DATASET_NAME=${BQ_DATASET_NAME}" >> /etc/environment

echo "export PROJECT_ID=${PROJECT_ID}" >> /etc/profile.d/spark.sh
echo "export DATA_BUCKET_NAME=${DATA_BUCKET_NAME}" >> /etc/profile.d/spark.sh
echo "export BQ_DATASET_NAME=${BQ_DATASET_NAME}" >> /etc/profile.d/spark.sh

source /etc/profile

gsutil cp gs://${COMPOSER_BUCKET_NAME}/dags/requirements.txt .
pip3 install --upgrade -r requirements.txt