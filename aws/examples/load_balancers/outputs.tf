
output "lb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.this.arn
}

output "lb_arn_suffix" {
  description = "Suffix of the ARN of the ALB"
  value       = aws_lb.this.arn_suffix
}

output "lb_desync_mitigation_mode" {
  description = "desync_mitigation_mode of the ALB"
  value       = aws_lb.this.desync_mitigation_mode
}

output "lb_dns_name" {
  description = "DNS of the ALB"
  value       = aws_lb.this.dns_name
}

output "lb_enable_cross_zone_load_balancing" {
  description = "Is the the ALB enabled to cross zone"
  value       = aws_lb.this.enable_cross_zone_load_balancing
}

output "lb_enable_deletion_protection" {
  description = "Is the ALB protected to deletion"
  value       = aws_lb.this.enable_deletion_protection
}

output "lb_enable_http2" {
  description = "Is the ALB HTTP2"
  value       = aws_lb.this.enable_http2
}

output "lb_internal" {
  description = "Is the ALB internal"
  value       = aws_lb.this.internal
}

output "lb_type" {
  description = "Type of the LB"
  value       = aws_lb.this.load_balancer_type
}

output "lb_name" {
  description = "Tag name of the ALB"
  value       = aws_lb.this.name
}

output "lb_security_groups" {
  description = "List of IDs of the SGPs of the ALB"
  value       = aws_lb.this.security_groups
}

output "lb_subnets" {
  description = "List of subnets IDs of the ALB"
  value       = aws_lb.this.subnets
}

output "lb_vpc_id" {
  description = "ID of the VPC of the ALB"
  value       = aws_lb.this.vpc_id
}

output "lb_zone_id" {
  description = "ID of the zone of the ALB"
  value       = aws_lb.this.zone_id
}

output "security_group_id" {
  description = "ID of the security group of the instance"
  value       = [for security_group in aws_security_group.this : security_group.id]
}

output "security_group_arn" {
  description = "ARN of the security group of the instance"
  value       = [for security_group in aws_security_group.this : security_group.arn]
}

output "security_group_name" {
  description = "Name of the security group of the instance"
  value       = [for security_group in aws_security_group.this : security_group.name]
}

output "security_group_vpc_id" {
  description = "ID of VPC where is the security group of the instance"
  value       = [for security_group in aws_security_group.this : security_group.vpc_id]
}

