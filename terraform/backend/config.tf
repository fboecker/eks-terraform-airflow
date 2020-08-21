# config.tf - terraform and providers configuration

terraform {
  required_version = "~> 0.13"
}

provider "aws" {
  # Set your AWS configuration here. For more information see the terraform
  # provider information: https://www.terraform.io/docs/providers/aws/index.html
  # You might need to set AWS_SDK_LOAD_CONFIG=1 to use your aws credentials file
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region     = var.AWS_REGION
  version    = "~> 3.0"
}

provider "random" {
  version = "~> 2.2"
}
