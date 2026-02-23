
locals {
  cidr_zero = "0.0.0.0/0"
  public_azs = { for ip in keys(var.public_subnets) :
    ip => data.aws_availability_zones.this.names[index(keys(var.public_subnets), ip)]
  }
  private_azs = { for ip in keys(var.private_subnets) :
    ip => data.aws_availability_zones.this.names[index(keys(var.private_subnets), ip)]
  }
}

data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block                           = var.cidr
  enable_network_address_usage_metrics = true
  tags = {
    Name = "vpc${var.tag_name}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "igw${var.tag_name}"
  }
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id
  route {
    cidr_block = local.cidr_zero
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "rt-main${var.tag_name}"
  }
}

resource "aws_flow_log" "this" {
  iam_role_arn    = aws_iam_role.this.arn
  log_destination = aws_cloudwatch_log_group.this.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/vpc/${var.tag_name}"
  retention_in_days = 1

  tags = {
    Name = var.tag_name
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy = file("${path.module}/vpc_flow_logs_service_role_policy.json")
  inline_policy {
    name   = "cloudwatch-access-vpc-flow-logs"
    policy = file("${path.module}/cloudwatch_role_policy.json")
  }
}
