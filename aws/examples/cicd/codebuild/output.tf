
output "node_codebuild_project_service_role" {
  description = "ARN of the service role of the node codebuild projects"
  value       = [for c in aws_codebuild_project.node : c.service_role]
}

output "java_codebuild_project_service_role" {
  description = "ARN of the service role of the java codebuild projects"
  value       = [for c in aws_codebuild_project.java : c.service_role]
}

output "node_codebuild_project_log_group" {
  description = "Cloudwatch log groups of the node codebuild proects"
  value       = flatten([for c in aws_codebuild_project.node : c.logs_config[*].cloudwatch_logs[*].group_name])
}

output "java_codebuild_project_log_group" {
  description = "Cloudwatch log groups of the java codebuild proects"
  value       = flatten([for c in aws_codebuild_project.java : c.logs_config[*].cloudwatch_logs[*].group_name])
}

output "node_codebuild_projects_names" {
  description = "Name of the node codebuild projects"
  value       = [for c in aws_codebuild_project.node : c.name]
}

output "java_codebuild_projects_names" {
  description = "Name of the java codebuild projects"
  value       = [for c in aws_codebuild_project.java : c.name]
}
