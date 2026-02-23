
output "codeploy_app_names" {
  description = "Names of the deployment app names"
  value       = [for a in aws_codedeploy_app.this : a.name]
}

output "codeploy_app_arns" {
  description = "ARNs of the deployment app names"
  value       = [for a in aws_codedeploy_app.this : a.arn]
}

output "codeploy_app_ids" {
  description = "IDs of the deployment app names"
  value       = [for a in aws_codedeploy_app.this : a.application_id]
}

output "codedeploy_deployment_gp_names" {
  description = "Names of the deployment groups"
  value       = [for c in aws_codedeploy_deployment_group.this : c.deployment_group_name]
}

output "codedeploy_deployment_gp_app_names" {
  description = "App names of the deployment groups"
  value       = [for c in aws_codedeploy_deployment_group.this : c.app_name]
}

output "codedeploy_deployment_gp_arns" {
  description = "ARNs of deployment groups"
  value       = [for c in aws_codedeploy_deployment_group.this : c.arn]
}

output "codedeploy_deployment_gp_ids" {
  description = "IDs of the deployment groups"
  value       = [for c in aws_codedeploy_deployment_group.this : c.id]
}

output "codedeploy_deployment_gp_service_role_arns" {
  description = "ARNs of the service role of each deployment group"
  value       = [for c in aws_codedeploy_deployment_group.this : c.service_role_arn]
}
