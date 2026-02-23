
output "ssh-conection" {
  value = "ssh -i ${aws_instance.this.key_name}.pem ec2-user@${aws_instance.this.public_ip}"
}

output "security_group_id" {
  description = "ID of the security group of the instance"
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN of the security group of the instance"
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "Name of the security group of the instance"
  value       = aws_security_group.this.name
}

output "security_group_vpc_id" {
  description = "ID of VPC where is the security group of the instance"
  value       = aws_security_group.this.vpc_id
}

output "elastic_ip" {
  description = "Elastic IP of the instance"
  value       = aws_eip.this[*].public_ip
}

output "instance_ami" {
  description = "ID of the AMI of the instance"
  value       = aws_instance.this.ami
}

output "instance_arn" {
  description = "ARN of the instance"
  value       = aws_instance.this.arn
}

output "instance_availability_zone" {
  description = "Name of the availabillity zone of the instance"
  value       = aws_instance.this.availability_zone
}

output "instance_id" {
  description = "ID of the instance"
  value       = aws_instance.this.id
}

output "instance_status" {
  description = "State of the instance (running or stopped)"
  value       = aws_instance.this.instance_state
}

output "instance_type" {
  description = "Instance type of the instance"
  value       = aws_instance.this.instance_type
}

output "instance_key_name" {
  description = "Name of the key_pair of the instance"
  value       = aws_instance.this.key_name
}

output "instance_primary_netwrok_interfae_id" {
  description = "ID of the ENI of the instance"
  value       = aws_instance.this.primary_network_interface_id
}

output "instance_private_dns" {
  description = "DNS of the private IP of the instance"
  value       = aws_instance.this.private_dns
}

output "instance_private_ip" {
  description = "Private IP of the instance"
  value       = aws_instance.this.private_ip
}

output "instance_public_dns" {
  description = "DNS of the public IP of the instance"
  value       = aws_instance.this.public_dns
}

output "instance_public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.this.public_ip
}

output "instance_root_block_device_volume_id" {
  description = "ID of the root EBS volume of the instance"
  value       = aws_instance.this.root_block_device[*].volume_id
}
