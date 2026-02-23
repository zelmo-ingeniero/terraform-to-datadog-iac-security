provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "enabled_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "dataflow.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "pubsub.googleapis.com",
    "storage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "container.googleapis.com"
  ])
  project = var.project_id
  service = each.key
}

