
locals {
  node_repos_raw = [for n in keys(var.node_repos) :
    { for e in var.node_repos[n] :
      "${n}-${e}" => {
        env  = e
        name = n
      }
    }
  ]
  node_repos = merge(local.node_repos_raw...)
  java_repos_raw = [for n in keys(var.java_repos) :
    { for e in var.java_repos[n] :
      "${n}-${e}" => {
        env  = e
        name = n
      }
    }
  ]
  java_repos = merge(local.java_repos_raw...)
}

resource "aws_codebuild_project" "node" {
  for_each = local.node_repos

  name         = each.key
  service_role = aws_iam_role.node[each.value.name].arn
  source {
    type = "NO_SOURCE"
    buildspec = templatefile("${path.module}/buildspec-node.yaml", {
      repo = each.value.name
    })
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
  }
  artifacts {
    type      = "S3"
    location  = var.artifact_bucket
    name      = "${each.key}.zip"
    path      = "${each.value.env}/${each.value.name}-build/"
    packaging = "ZIP"
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.node[each.key].name
    }
  }

  tags = {
    Name = each.key
  }

  lifecycle {
    precondition {
      condition     = length(var.artifact_bucket) > 0
      error_message = "Bad call to module | An artifact bucket name is required"
    }
  }
}

resource "aws_cloudwatch_log_group" "node" {
  for_each = local.node_repos

  name              = "/aws/codebuild/${each.key}"
  retention_in_days = 1

  tags = {
    Name = each.key
  }
}

# duplicated code

resource "aws_codebuild_project" "java" {
  for_each = local.java_repos

  name         = each.key
  service_role = aws_iam_role.java[each.value.name].arn
  source {
    type = "NO_SOURCE"
    buildspec = templatefile("${path.module}/buildspec-java.yaml", {
      repo = each.value.name
    })
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
  }
  artifacts {
    type      = "S3"
    location  = var.artifact_bucket
    name      = "${each.key}.zip"
    path      = "${each.value.env}/${each.value.name}-build/"
    packaging = "ZIP"
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.java[each.key].name
    }
  }

  tags = {
    Name = each.key
  }

  lifecycle {
    precondition {
      condition     = length(var.artifact_bucket) > 0
      error_message = "Bad call to module | One bucket name with artifact inside it is required"
    }
  }
}

resource "aws_cloudwatch_log_group" "java" {
  for_each = local.java_repos

  name              = "/aws/codebuild/${each.key}"
  retention_in_days = 1

  tags = {
    Name = each.key
  }
}

