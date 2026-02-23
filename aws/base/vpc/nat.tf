
# locals {
#   nat-key = length(keys(var.private-subnets)) != 0 ? keys(var.public-subnets)[0] : null
#   nat = {
#     (local.nat-key) = var.private-subnets[local.nat-key]
#   }
# }

# resource "aws_eip" "eip-to-nat" {
#   count  = local.nat-key == null ? 0 : 1
#   domain = "vpc"
#   tags = {
#     Name = "eip-to-nat-${local.nat-key}${var.suffix}"
#   }
# }

# resource "aws_nat_gateway" "nat-private" {
#   count             = local.nat-key == null ? 0 : 1
#   allocation_id     = aws_eip.eip-to-nat[count.index].id
#   subnet_id         = aws_subnet.public[local.nat-key].id
#   connectivity_type = "public"
#   depends_on        = [aws_internet_gateway.ig]
#   tags = {
#     Name = "nat-${local.nat-key}${var.suffix}"
#   }
# }
