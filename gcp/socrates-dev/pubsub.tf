resource "google_pubsub_topic" "topic" {
  name = "socrates-dev-topic"
}

resource "google_pubsub_subscription" "subscription" {
  name  = "socrates-dev-sub"
  topic = google_pubsub_topic.topic.name
}

