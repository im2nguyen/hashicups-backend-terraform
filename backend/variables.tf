variable "environment_tag" {
  description = "Environment tag"
  default     = "Learn"
}

variable "region" {
  description = "The region Terraform deploys your instance"
  default     = "us-east-2"
}

variable "pull_request_id" {
  description = "Pull Request ID"
  default     = "pull-request-1"
}