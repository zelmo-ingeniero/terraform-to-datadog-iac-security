
data "aws_caller_identity" "this" {}

data "aws_region" "this" {}

data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "node" {
  for_each = toset(keys(var.node_repos))

  name                = "codebuild-service-role-${each.key}"
  description         = "Permissions to be attached to codebuild project: ${each.key} and their envs"
  assume_role_policy  = file("${path.module}/codebuild_service_role_policy.json")
  managed_policy_arns = [data.aws_iam_policy.AmazonS3FullAccess.arn]

  tags = {
    Name = each.key
  }
}

resource "aws_iam_role_policy" "node" {
  for_each = local.node_repos

  name = "CBuild-${each.key}-inline-policy"
  role = aws_iam_role.node[each.value.name].name
  policy = templatefile("${path.module}/codebuild_project_policy.json", {
    account_id      = data.aws_caller_identity.this.id
    region          = data.aws_region.this.id
    artifact_bucket = var.artifact_bucket
  })
}

# duplicated code

resource "aws_iam_role" "java" {
  for_each = toset(keys(var.java_repos))

  name                = "codebuild-service-role-${each.key}"
  description         = "Permissions to be attached to codebuild project: ${each.key} and their envs"
  assume_role_policy  = file("${path.module}/codebuild_service_role_policy.json")
  managed_policy_arns = [data.aws_iam_policy.AmazonS3FullAccess.arn]

  tags = {
    Name = each.key
  }
}

resource "aws_iam_role_policy" "java" {
  for_each = local.java_repos

  name = "CBuild-${each.key}-inline-policy"
  role = aws_iam_role.java[each.value.name].name
  policy = templatefile("${path.module}/codebuild_project_policy.json", {
    account_id      = data.aws_caller_identity.this.id
    region          = data.aws_region.this.id
    artifact_bucket = var.artifact_bucket
  })
}
