
data "aws_subnet" "this" {
  id = var.subnet
}

data "aws_vpc" "this" {
  id = data.aws_subnet.this.vpc_id
}

data "template_cloudinit_config" "this" {
  dynamic "part" {
    for_each = var.scripts
    content {
      content_type = "text/x-shellscript"
      content      = file("${path.module}/scripts/${part.value}")
    }
  }
}

data "aws_ami" "AL_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }
}

data "aws_ami" "AL2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*.1-x86_64-gp2"]
  }
}
