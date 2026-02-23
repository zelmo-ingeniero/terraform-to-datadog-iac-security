resource "google_project_iam_member" "user_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "user:sergio.valencia@example.com"
}

resource "google_project_iam_member" "compute_dataflow_roles" {
  for_each = {
    "dataflow.admin"                      = "roles/dataflow.admin"
    "dataflow.worker"                     = "roles/dataflow.worker"
    "storage.admin"                       = "roles/storage.admin"
    "pubsub.editor"                       = "roles/pubsub.editor"
    "bigquery.dataEditor"                = "roles/bigquery.dataEditor"
    "container.defaultNodeServiceAccount" = "roles/container.defaultNodeServiceAccount"
  }

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:123412341234-compute@developer.gserviceaccount.com"
}

