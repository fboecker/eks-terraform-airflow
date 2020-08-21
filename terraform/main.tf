terraform {
  required_version = "~> 0.13"
  backend "s3" {
    bucket         = "terraform-state-${data.aws_caller_identity.current.account_id}"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

data "aws_region" "current" {}
