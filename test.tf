
#local variables
locals {
  topics = {
    nguyen-topic = {
      creator      = "nguyen-vo1"
      owner        = "nguyen-vo"
      appliocation = "terraform-test"
      name         = "terraform-to-gcp"
      subscription = "terraform-to-gcp-sub"
    }
  }
}

#create input variable
variable "gcp_project" {
  type = object({
    projectID   = string
    projectName = string
    region      = string
    zone        = string
  })

}
#create a firestore variable with default values
variable "firestore" {
  description = "firestore"
  # the value will be assigned by terraform during execution
  # the value is defined in the gcp_var.json
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.0.0"
    }
  }
}


#define provider
provider "google" {
  project = var.gcp_project.projectID
  region  = var.gcp_project.region
  zone    = var.gcp_project.zone
}

resource "google_project" "test_project" {
  name       = var.gcp_project.projectName
  project_id = var.gcp_project.projectID
}

# enable pubsub service
resource "google_project_service" "services" {
  project  = google_project.test_project.project_id #imolicitly make this resource depends on the creation of google_project
  for_each = toset(["pubsub.googleapis.com", "firestore.googleapis.com"])
  service  = each.key

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

# create pubsub topic
resource "google_pubsub_topic" "terraform-to-gcp" {
  project = google_project.test_project.project_id
  name    = local.topics.nguyen-topic.name
  labels = {
    creator      = local.topics.nguyen-topic.creator
    owner        = local.topics.nguyen-topic.owner
    appliocation = local.topics.nguyen-topic.appliocation
    name         = local.topics.nguyen-topic.name
  }
  message_storage_policy {
    allowed_persistence_regions = ["europe-west3"]
  }

}

# create pubsub subscription and attach to topic
resource "google_pubsub_subscription" "terraform-to-gcp-sub" {
  project                    = google_project.test_project.project_id
  name                       = local.topics.nguyen-topic.name
  topic                      = google_pubsub_topic.terraform-to-gcp.name
  ack_deadline_seconds       = 600       #600s = 10m
  message_retention_duration = "604800s" #604800s = 1 week
  enable_message_ordering    = false
  #   retry_policy {
  #     minimum_backoff = "1s"
  #     maximum_backoff = "10s"
  #     maximum_doublings = 10
  #     #dead_letter_policy {
  #     #  dead_letter_topic = google_pubsub_topic.terraform-to-gcp.name
  #     #}
  #   }
  labels = {
    creator      = local.topics.nguyen-topic.creator
    owner        = local.topics.nguyen-topic.owner
    appliocation = local.topics.nguyen-topic.appliocation
    name         = local.topics.nguyen-topic.subscription
  }
}
#enable firestore service
resource "google_app_engine_application" "app" {
  project       = google_project.test_project.project_id
  location_id   = var.gcp_project.region
  database_type = "CLOUD_FIRESTORE"
}
#create a document
resource "google_firestore_document" "mydoc" {
  collection  = var.firestore.collection
  document_id = var.firestore.docID
  fields      = jsonencode(var.firestore.fields)
  depends_on  = [google_project.test_project, google_project_service.services]
}
