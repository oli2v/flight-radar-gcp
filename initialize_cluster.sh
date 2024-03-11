#!bin/bash
gsutil cp gs://europe-west9-flight-radar-c-81396519-bucket/dags/requirements.txt .
pip3 install --upgrade -r requirements.txt