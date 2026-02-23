
resource "aws_route_table" "public" {
  for_each = var.public_subnets

  vpc_id = aws_vpc.this.id
  route {
    cidr_block = local.cidr_zero
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "rtb-public-${each.value}${var.tag_name}"
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.key
  availability_zone       = local.public_azs[each.key]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${each.value}${var.tag_name}"
  }
}


#
# private subnets
#

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.key
  availability_zone       = local.private_azs[each.key]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-${each.value}${var.tag_name}"
  }
}

resource "aws_route_table" "private" {
  for_each = var.private_subnets

  vpc_id = aws_vpc.this.id
  route {
    cidr_block = local.cidr_zero
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "rtb-private-${each.value}${var.tag_name}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
