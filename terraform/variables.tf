#
# Variables Configuration
#

variable "cluster-name" {
  default = "terraform-eks-airflow"
  type    = string
}

variable "region" {
  default     = "eu-west-1"
  description = "AWS region"
}