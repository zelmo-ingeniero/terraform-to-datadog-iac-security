
locals {
  deploy_gps = merge([
    for r in keys(var.apps) : {
      for e in var.apps[r] : "${r}-${e}" => r
    }
  ]...)
}

resource "aws_codedeploy_app" "this" {
  for_each = var.apps

  compute_platform = "Server"
  name             = each.key

  tags = {
    Name = each.key
  }
}

resource "aws_codedeploy_deployment_group" "this" {
  for_each = local.deploy_gps

  app_name               = each.value
  deployment_group_name  = each.key
  service_role_arn       = var.role_arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  deployment_style {
    deployment_type = "IN_PLACE"
  }
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      value = var.ec2_nametag
      type  = "KEY_AND_VALUE"
    }
  }

  tags = {
    Name = each.key
  }

  depends_on = [aws_codedeploy_app.this]
}
