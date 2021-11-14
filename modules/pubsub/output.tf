output "created_topic" {
  value = google_pubsub_topic.terraform-to-gcp
}

output "created_subscription" {
  value = google_pubsub_subscription.terraform-to-gcp-sub
}
