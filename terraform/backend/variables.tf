# variables.tf - user settings. For provider settings see config.tf

variable "custom_tags" {
  description = "Map of custom tags to apply to every resource"
  type        = map(string)
  default     = {}
}

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}