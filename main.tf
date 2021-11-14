
#local variables
locals {
  baz = "aaa"
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

terraform {
  required_version = ">=1.0.0"
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

#resrouce block
#resource "provider_resouceName" "local-name" {
# local name is for Terraform to reference the resource current state and new configurations for creating and updating
#  <Argument> = <Value>
#}
resource "google_project" "test_project" {
  name       = var.gcp_project.projectName
  project_id = var.gcp_project.projectID
}

# enable pubsub service
resource "google_project_service" "services" {
  project  = google_project.test_project.project_id #implicitly make this resource depends on the creation of google_project
  for_each = toset(["pubsub.googleapis.com", "firestore.googleapis.com"])
  service  = each.key

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}
module "pubsub-terraform-to-gcp" {
  source                      = "./modules/pubsub"
  project_id                  = google_project.test_project.project_id
  topic_name                  = local.topics.nguyen-topic.name
  allowed_persistence_regions = ["europe-west3"]
  labels = {
    creator      = local.topics.nguyen-topic.creator
    owner        = local.topics.nguyen-topic.owner
    appliocation = local.topics.nguyen-topic.appliocation
    name         = local.topics.nguyen-topic.name
    # expression examples
    name              = "string-interpolation-${local.baz}"
    foo               = local.baz == "aaa" ? "short-hand" : "if-statement"
    long_if_statement = "hello-%{if local.baz != ""}-${local.baz}-%{else}-unammed-%{endif}"
  }
}

module "pubsub-local-top-gcp" {
  source                      = "./modules/pubsub"
  project_id                  = google_project.test_project.project_id
  topic_name                  = "local-to-gcp"
  allowed_persistence_regions = ["europe-west3"]
}

#enable firestore service
resource "google_app_engine_application" "app" {
  project       = google_project.test_project.project_id
  location_id   = var.gcp_project.region
  database_type = "CLOUD_FIRESTORE"
}

module "firestore-doc" {
  source     = "./modules/firestore"
  project_id = google_project.test_project.project_id
  region     = var.gcp_project.region
  firestore  = var.test-collection
  depends_on = [google_project.test_project, google_project_service.services]
}
output "created_document" {
  value = module.firestore-doc.doc_created
}
output "topic" {
  value = [for k, v in local.topics.nguyen-topic : "${k}=${v}"]
}
output "loop-expression" {
  value = <<-EOT
      %{for i in range(0, 3)}
        "${local.baz}-${i}"
      %{endfor}
    EOT
}
output "multi-line-string" {
  value = <<-EOT
      multi-line
      string
      interpolation
    EOT
}
