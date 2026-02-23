
resource "aws_iam_role" "this" {
  name                = "project-codeploy-service-role"
  assume_role_policy  = file("${path.module}/codeploy_service_role_policy.json")
  managed_policy_arns = [data.aws_iam_policy.awscodedeployrole.arn]
  # to cross account
  # inline_policy {
  #   name   = "kms-codeploy-cross-account"
  #   policy = file("${path.module}/kms_codeploy_cross_account_policy.json")
  # }
  inline_policy {
    name = "s3-codeploy-cross-account"
    policy = templatefile("${path.module}/s3_codeploy_cross_account_policy.json", {
      external_bucket = "bucket-in-other-account"
    })
  }

  tags = {
    name = "project-codeploy-service-role"
  }
}

module "codebuild" {
  source          = "./codebuild"
  artifact_bucket = module.s3.bucket_names[0]
  node_repos = {
    repo-two = ["dev01"]
  }
  # java_repos = {
  #   repo-one   = ["dev01", "uat01"]
  # }
}

module "codeploy" {
  source      = "./codeploy"
  ec2_nametag = "non-exists"
  role_arn    = aws_iam_role.this.arn
  apps = {
    repo-one = ["dev01", "uat01"]
  }
}

module "codeploy2" {
  source      = "./codeploy"
  ec2_nametag = "srv-lpar2rrd"
  role_arn    = aws_iam_role.this.arn
  apps = {
    repo-two = ["dev01"]
  }
}

module "pipeline" {
  source      = "./codepipeline"
  bucket_name = module.s3.bucket_names[1]
}

output "cicd" {
  value = [
    # module.codebuild,
    # module.codeploy,
    # module.codeploy2,
    # module.pipeline
  ]
}
