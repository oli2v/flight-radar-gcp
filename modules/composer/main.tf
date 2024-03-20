resource "google_service_account" "composer_service_account" {
  provider     = google-beta
  account_id   = "composer-service-account"
  display_name = "Service Account for Composer Environment"
}

resource "google_project_iam_member" "composer_service_account_composer_worker" {
  provider = google-beta
  project  = local.project_id
  member   = "serviceAccount:${google_service_account.composer_service_account.email}"
  role     = "roles/composer.worker"
}

resource "google_project_iam_member" "composer_service_account_dataproc_editor" {
  provider = google-beta
  project  = local.project_id
  member   = "serviceAccount:${google_service_account.composer_service_account.email}"
  role     = "roles/dataproc.editor"
}

resource "google_service_account_iam_member" "composer_service_account" {
  provider           = google-beta
  service_account_id = google_service_account.composer_service_account.name
  role               = "roles/composer.ServiceAgentV2Ext"
  member             = "serviceAccount:service-${data.google_project.project.number}@cloudcomposer-accounts.iam.gserviceaccount.com"
}

resource "google_storage_bucket" "composer_bucket" {
  name     = "${local.project_name}-composer-bucket"
  project  = local.project_id
  location = local.region
}

resource "google_storage_bucket_object" "dag_files" {
  for_each = var.files
  name     = each.value
  source   = each.key
  bucket   = google_storage_bucket.composer_bucket.id
}

resource "google_composer_environment" "composer_environment" {
  provider = google-beta
  name     = "${local.project_name}-environment"
  region   = local.region

  config {

    software_config {
      image_version = "composer-2.6.2-airflow-2.6.3"
      env_variables = {
        REGION                = local.region
        DATAPROC_CLUSTER_NAME = "${local.project_name}-cluster"
        COMPOSER_BUCKET_NAME  = "${local.project_name}-composer-bucket"
      }
    }

    workloads_config {
      scheduler {
        cpu        = 0.5
        memory_gb  = 1.875
        storage_gb = 1
        count      = 1
      }
      triggerer {
        cpu       = 0.5
        memory_gb = 0.5
        count     = 1
      }
      web_server {
        cpu        = 0.5
        memory_gb  = 1.875
        storage_gb = 1
      }
      worker {
        cpu        = 0.5
        memory_gb  = 1.875
        storage_gb = 1
        min_count  = 1
        max_count  = 3
      }


    }
    environment_size = "ENVIRONMENT_SIZE_SMALL"

    node_config {
      service_account = google_service_account.composer_service_account.email
    }


  }
  storage_config {
    bucket = google_storage_bucket.composer_bucket.name
  }
}

