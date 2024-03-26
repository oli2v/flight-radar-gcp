data "google_project" "project" {
}

output "project_number" {
  value = data.google_project.project.number
}

output "composer_bucket_name" {
  value = google_storage_bucket.composer_bucket.name
}
