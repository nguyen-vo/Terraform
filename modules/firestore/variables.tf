#create a firestore variable with default values
variable "firestore" {
  description = "firestore"
  # the value will be assigned by terraform during execution
  # the value is defined in the gcp_var.json
}

variable "project_id" {
  description = "gcp project id"
}

variable "region" {
  description = "gcp region"
}
