#!bin/bash
COMPOSER_BUCKET_NAME=$(/usr/share/google/get_metadata_value attributes/COMPOSER_BUCKET_NAME)
gsutil cp gs://${COMPOSER_BUCKET_NAME}/dags/requirements.txt .
pip3 install --upgrade -r requirements.txt