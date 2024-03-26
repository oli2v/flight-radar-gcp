terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.20.0"
    }
  }
}

provider "google" {
  credentials = file("flight-radar-service-account-credentials.json")

  project = local.project_id
  region  = local.region
}


provider "google-beta" {
  credentials = file("flight-radar-service-account-credentials.json")

  project = local.project_id
  region  = local.region
}


module "composer" {
  source = "./modules/composer"
}

module "dataproc" {
  source                       = "./modules/dataproc"
  dataproc_master_machine_type = "n2-standard-2"
  dataproc_worker_machine_type = "n2-standard-2"
  composer_bucket_name         = module.composer.composer_bucket_name
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = "${replace(local.project_name, "-", "_")}_dataset"
  location   = local.region
}

resource "google_storage_bucket" "data_bucket" {
  name          = "${local.project_name}-data-bucket"
  project       = local.project_id
  location      = local.region
  force_destroy = true
}
