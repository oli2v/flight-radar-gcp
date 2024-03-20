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

data "google_project" "project" {
}

output "project_number" {
  value = data.google_project.project.number
}
