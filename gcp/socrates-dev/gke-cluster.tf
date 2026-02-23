resource "google_container_cluster" "autopilot_cluster" {
  name     = "gke-cluster-socrates-dev"
  location = var.region

  enable_autopilot = true
}

