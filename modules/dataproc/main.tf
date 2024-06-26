resource "google_storage_bucket" "dataproc_staging_bucket" {
  name          = "${local.project_name}-dataproc-staging-bucket"
  location      = local.region
  force_destroy = true
}

resource "google_storage_bucket" "dataproc_temp_bucket" {
  name          = "${local.project_name}-dataproc-temp-bucket"
  location      = local.region
  force_destroy = true
}

resource "google_storage_bucket" "dataproc_init_bucket" {
  name                        = "${local.project_name}-dataproc-init-bucket"
  location                    = local.region
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket_object" "initialization_script" {
  name   = var.dataproc_init_script_name
  source = var.dataproc_init_script_name
  bucket = google_storage_bucket.dataproc_init_bucket.id
}

resource "google_service_account" "dataproc_service_account" {
  account_id   = "dataproc-service-account"
  display_name = "Service Account for Dataproc cluster"
}

resource "google_project_iam_member" "dataproc_service_account" {
  project = local.project_id
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

resource "google_project_iam_member" "dataproc_service_account_storage_admin" {
  project = local.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

resource "google_project_iam_member" "dataproc_service_account_compute_admin" {
  project = local.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

resource "google_project_iam_member" "dataproc_service_account_bigquery_admin" {
  project = local.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

resource "google_dataproc_cluster" "flight_radar_cluster" {
  name    = "${local.project_name}-cluster"
  project = local.project_id
  region  = local.region

  cluster_config {
    staging_bucket = google_storage_bucket.dataproc_staging_bucket.name
    temp_bucket    = google_storage_bucket.dataproc_temp_bucket.name

    gce_cluster_config {
      service_account = google_service_account.dataproc_service_account.email
      service_account_scopes = [
        "cloud-platform"
      ]
      metadata = {
        PROJECT_ID           = local.project_id
        COMPOSER_BUCKET_NAME = var.composer_bucket_name
        DATA_BUCKET_NAME     = "${local.project_name}-data-bucket"
        BQ_DATASET_NAME      = "${replace(local.project_name, "-", "_")}_dataset"
      }
    }

    master_config {
      num_instances = 1
      machine_type  = var.dataproc_master_machine_type
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = var.dataproc_master_bootdisk
      }
    }

    worker_config {
      num_instances = var.dataproc_workers_count
      machine_type  = var.dataproc_worker_machine_type
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = var.dataproc_worker_bootdisk
      }
    }

    initialization_action {
      script      = "gs://${google_storage_bucket.dataproc_init_bucket.name}/${var.dataproc_init_script_name}"
      timeout_sec = 500
    }

  }
}
