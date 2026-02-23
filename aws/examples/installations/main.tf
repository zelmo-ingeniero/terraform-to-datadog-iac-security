
locals {
  ami_id = var.os == "AL2" ? data.aws_ami.AL2.id : data.aws_ami.AL_2023.id
}

resource "aws_security_group" "this" {
  description = "The security group of the ${var.name}"
  vpc_id      = data.aws_vpc.this.id
  name        = "sgp${var.name}"

  dynamic "ingress" {
    for_each = var.ports
    content {
      description = "ingress-rule-number-${ingress.key}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "out allouwed to internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sgp-${var.name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "this" {
  count    = var.include_eip ? 1 : 0
  instance = aws_instance.this.id
  domain   = "vpc"
  tags = {
    Name = "eip-${var.name}"
  }
}

resource "aws_ec2_instance_state" "this" {
  instance_id = aws_instance.this.id
  state       = var.status
}

resource "aws_instance" "this" {
  ami                    = local.ami_id
  instance_type          = var.type
  key_name               = var.key_pair
  subnet_id              = data.aws_subnet.this.id
  vpc_security_group_ids = [aws_security_group.this.id]
  metadata_options {
    http_tokens = "required"
  }
  user_data  = data.template_cloudinit_config.this.rendered
  monitoring = false
  root_block_device {
    encrypted   = true
    volume_size = var.volume_size
    volume_type = var.volume_type
    tags = {
      Name = "vol-${var.name}"
    }
  }
  tags = {
    Name = var.name
  }
}
