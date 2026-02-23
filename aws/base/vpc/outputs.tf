
output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_default_network_acl_id" {
  description = "ID of the ACL of the VPC"
  value       = aws_vpc.this.default_network_acl_id
}

output "vpc_main_route_table_id" {
  description = "ID of the main (defailt) route table of the VPC"
  value       = aws_vpc.this.main_route_table_id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway of the VPC"
  value       = aws_internet_gateway.this.id
}

output "internet_gateway_arn" {
  description = "ID of the internet gateway of the VPC"
  value       = aws_internet_gateway.this.arn
}

output "route_table_arns" {
  description = "List of ARNs of the route tables of the public subnets"
  value       = [for r in aws_route_table.public : r.arn]
}

output "route_table_gateway_id" {
  description = "List of Gateway IDs of the route tables of the public subnets"
  value       = [for r in aws_route_table.public : r.id]
}

output "public_subnets_ids" {
  description = "List of IDs of the public subnets"
  value       = [for s in aws_subnet.public : s.id]
}

output "public_subnets_cidrs" {
  description = "List of CIDRs of the public subnets"
  value       = [for s in aws_subnet.public : s.cidr_block]
}

output "public_subnets_availability_zone_names" {
  description = "List of availability zones of the public subnets"
  value       = [for s in aws_subnet.public : s.availability_zone]
}

output "public_subnets_arns" {
  description = "List of ARNs of the public subnets"
  value       = [for s in aws_subnet.public : s.arn]
}

#
# private
#

output "private_subnets_ids" {
  description = "List of IDs of the private subnets"
  value       = [for s in aws_subnet.private : s.id]
}

output "private_subnets_cidrs" {
  description = "List of CIDRs of the private subnets"
  value       = [for s in aws_subnet.private : s.cidr_block]
}

output "private_subnets_availability_zone_names" {
  description = "List of availability zones of the private subnets"
  value       = [for s in aws_subnet.private : s.availability_zone]
}

output "private_subnets" {
  description = "List of ARNs of the private subnets"
  value       = [for s in aws_subnet.private : s.arn]
}
