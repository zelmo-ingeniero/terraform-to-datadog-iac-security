
# terraform {
#   backend "s3" {
#     profile                  = "infra"
#     shared_credentials_files = ["../.credentials"]
#     bucket                   = "infraestructura-exos-tfbackend"
#     key                      = "examples-tfstate"
#     region                   = "us-east-1"
#     encrypt                  = true
#   }
# }

terraform {
  required_version = "~> 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.6"
    }
  }
}


provider "aws" {
  shared_config_files      = ["../.credentials"]
  shared_credentials_files = ["../.credentials"]
  profile                  = "default"
}
