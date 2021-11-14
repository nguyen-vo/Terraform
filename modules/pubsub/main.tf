resource "google_pubsub_topic" "terraform-to-gcp" {
  project = var.project_id
  name    = var.topic_name
  labels  = var.labels
  message_storage_policy {
    allowed_persistence_regions = var.allowed_persistence_regions
  }

}

resource "google_pubsub_subscription" "terraform-to-gcp-sub" {
  project                    = var.project_id
  name                       = "${var.topic_name}-sub"
  topic                      = google_pubsub_topic.terraform-to-gcp.name
  ack_deadline_seconds       = 600       #600s = 10m
  message_retention_duration = "604800s" #604800s = 1 week
  enable_message_ordering    = true
  #   retry_policy {
  #     minimum_backoff = "1s"
  #     maximum_backoff = "10s"
  #     maximum_doublings = 10
  #     #dead_letter_policy {
  #     #  dead_letter_topic = google_pubsub_topic.terraform-to-gcp.name
  #     #}
  #   }
  labels = var.labels
}
