
# data "aws_iam_policy" "AWSElasticBeanstalkEnhancedHealth" {
#   arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
# }

# data "aws_iam_policy" "AWSElasticBeanstalkService" {
#   arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
# }

# data "aws_iam_policy" "AmazonS3FullAccess" {
#   arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }

# data "aws_iam_policy" "AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy" {
#   arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
# }

# data "aws_iam_policy" "AWSCodePipeline_FullAccess" {
#   arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
# }

resource "aws_iam_role" "this" {
  name                = "codepipeline-service-role"
  assume_role_policy  = file("${path.module}/codepipeline_service_role_policy.json")
  managed_policy_arns = [data.aws_iam_policy.AWSCodePipeline_FullAccess.arn]

  tags = {
    Name = "codepipeline-service-role"
  }
}

# role cross account
# resource "aws_iam_role" "cross_account" {
#   name               = "Tmp-Dev-Role-Cross-Accounts-to-Pipeline"
#   assume_role_policy = file("${path.module}/codepipeline_service_role_cross_account_policy.json")
#   managed_policy_arns = [
#     data.aws_iam_policy.AmazonS3FullAccess.arn,
#     data.aws_iam_policy.AWSElasticBeanstalkEnhancedHealth.arn,
#     data.aws_iam_policy.AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy.arn,
#     data.aws_iam_policy.AWSElasticBeanstalkService.arn
#   ]
#   inline_policy {
#     name   = "EBS-Acces-to-Modify-ELB"
#     policy = file("${path.module}/ebs_elb_policy.json")
#   }
#   inline_policy {
#     name   = "Policy-Cross-Account-Permission-BeanStalk"
#     policy = file("${path.module}/beanstalk_cross_account_policy.json")
#   }
#   inline_policy {
#     name   = "Policy-Cross-Accounts-Permission-CodeDeploy-in-S3"
#     policy = file("${path.module}/beanstalk_s3_cross_account_policy.json")
#   }
#   inline_policy {
#     name   = "Policy-Permission-to-KMS-CentralRepo-to-BeanStalk"
#     policy = file("${path.module}/kms_cross_account_policy.json")
#   }
#   inline_policy {
#     name   = "wc-dev-policy-cross-account"
#     policy = file("${path.module}/codeploy_cross_account_policy.json")
#   }

#   tags = {
#     Name = "Tmp-Dev-Role-Cross-Accounts-to-Pipeline"
#   }
# }
