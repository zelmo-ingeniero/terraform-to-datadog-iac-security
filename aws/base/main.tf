
terraform {
  required_version = "~> 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.6"
    }
  }
  # backend "s3" {
  #   profile                  = "infra"
  #   shared_credentials_files = ["../.credentials"]
  #   bucket                   = "infraestructura-exos-terraform-state"
  #   key                      = "infraestructura-exos-base-state"
  #   region                   = "us-east-1"
  #   encrypt                  = true
  # }
}

provider "aws" {
  shared_config_files      = ["../.credentials"]
  shared_credentials_files = ["../.credentials"]
  profile                  = "default"
}

data "aws_caller_identity" "this" {}

data "aws_region" "this" {}

# module "terraform_state" {
#   source = "./s3/"
#   buckets = {
#     # equal to line 13
#     infraestructura-exos-terraform-state = ["versioning"] # , "logging"]
#   }
# }

# module "internal_vpc" {
#   source = "./vpc"
#   cidr   = "172.20.0.0/16"
#   private_subnets = {
#     "172.20.0.0/20"  = "01"
#     "172.20.16.0/20" = "02"
#     "172.20.32.0/20" = "03"
#   }
# }

# import {
#   to = aws_eip.lpar2
#   id = "eipalloc-03499d260170d2639"
# }



output "this" {
  description = "Base modules called"
  value = [
    # module.terraform_state,
    # module.internal_vpc,
  ]
}

output "check" {
  description = "Only enable the correct region"
  value = [
    data.aws_region.this.id,
    data.aws_caller_identity.this.id
  ]
  precondition {
    condition     = data.aws_region.this.id == "us-east-1" # virginia
    error_message = "The region should be us-east-1"
  }
  precondition {
    condition     = data.aws_caller_identity.this.id == "121336885792"
    error_message = "The AWS account ID is different to the aws-infraestructura-exos account ID"
  }
}

