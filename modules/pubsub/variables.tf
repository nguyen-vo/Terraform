variable "project_id" {
  type = string
}

variable "allowed_persistence_regions" {
  type = list(string)
}

variable "topic_name" {
  type = string
}

variable "labels" {
  type = map(string)
  default = {
  }
}
