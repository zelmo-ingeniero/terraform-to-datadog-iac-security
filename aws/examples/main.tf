
data "aws_caller_identity" "this" {}

data "aws_region" "this" {}



resource "local_file" "foo" {
  content  = "foo!"
  filename = "${path.module}/foo.bar"
}

# data "aws_key_pair" "this" {
#   key_name = "sysadmin"
# }

# module "vpc" {
#   source   = "./vpc"
#   cidr     = "172.20.0.0/16"
#   tag_name = "-to-ansible"
#   public_subnets = {
#     "172.20.0.0/20"  = "first"
#     "172.20.16.0/20" = "second"
#   }
# }

# module "installations" {
#   source = "./installations"
#   # status      = "running"
#   # type        = "t2.micro"
#   key_pair = data.aws_key_pair.this.key_name
#   subnet   = module.vpc.public_subnets_ids[0]
#   ports    = [22]
#   name     = "to-ansible"
#   os       = "AL2"
#   # with_eip    = false
#   # volume_size = 8
#   # volume_type = "gp3"
# }

# module "installations2" {
#   source = "./installations"
#   # status      = "running"
#   # type        = "t2.micro"
#   key_pair = data.aws_key_pair.this.key_name
#   subnet   = module.vpc.public_subnets_ids[1]
#   ports    = [22]
#   name     = "to-ansible-2"
#   # with_eip    = false
#   # volume_size = 8
#   # volume_type = "gp3"
# }

# module "cicd" {
#   source = "./cicd"
# }

# module "s3" {
#   source = "./s3"
#   buckets = {
#     "tmp-to-codebuild-${data.aws_caller_identity.this.id}" = ["versioning", "logging"]
#     "tmp-to-pipeline-${data.aws_caller_identity.this.id}"  = ["versioning", "logging"]
#   }
#   logging = "logs-bucket-${data.aws_caller_identity.this.id}"
# }

# output "examples" {
#   description = "Ouputs and datas from the modules"
#   value = [
#     module.vpc,
#   ]
# }

# output "check" {
#   description = "Only enable the correct region"
#   value = {
#     "region"     = data.aws_region.this.id,
#     "account_id" = data.aws_caller_identity.this.id
#   }
#   precondition {
#     condition     = data.aws_region.this.id == "us-east-1" # virginia
#     error_message = "The region in .credentials file should be us-east-1"
#   }
#   precondition {
#     condition     = data.aws_caller_identity.this.id == "121336885792"
#     error_message = "The AWS account ID in .credentials file is different to the aws-infraestructura-exos account ID"
#   }
# }
