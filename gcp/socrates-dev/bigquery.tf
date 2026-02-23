resource "google_bigquery_dataset" "dataset" {
  dataset_id = "dataset"
  location   = var.region
}

resource "google_bigquery_table" "transactions" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "transactions"

  schema = jsonencode([
    { name = "url",    type = "STRING", mode = "NULLABLE" },
    { name = "review", type = "STRING", mode = "NULLABLE" }
  ])
}

