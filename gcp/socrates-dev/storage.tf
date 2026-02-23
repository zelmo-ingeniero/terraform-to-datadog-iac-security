resource "google_storage_bucket" "dataflow_bucket" {
  name     = "bucket-dataflow-pubsub-bigquery-459321"
  location = var.region
}

