# This file defines the variables

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
variable "test-collection" {
  description = "test collection"
  # the value will be assigned by terraform during execution
  # the value is defined in the gcp_var.json
}
