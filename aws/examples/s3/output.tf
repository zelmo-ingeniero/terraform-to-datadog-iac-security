
output "bucket_names" {
  description = "Names of the buckets"
  value       = [for b in aws_s3_bucket.this : b.id]
}

output "bucket_arns" {
  description = "ARNs of the buckets"
  value       = [for b in aws_s3_bucket.this : b.arn]
}

output "bucket_domain_names" {
  description = "DNS of the buckets"
  value       = [for b in aws_s3_bucket.this : b.bucket_domain_name]
}

output "bucket_versioning_enabled_names" {
  description = "Names of the buckets who have versioning and object_lock enabled"
  value = compact([for b in aws_s3_bucket.this :
    b.versioning[0].enabled && b.object_lock_enabled ? b.id : null
  ])
}

output "logging_bucket_name" {
  description = "Name of the logging bucket if exists"
  value       = try(aws_s3_bucket.logging[0].id, [])
}

output "logging_bucket_arn" {
  description = "ARN of the logging bucket if exists"
  value       = try(aws_s3_bucket.logging[0].arn, [])
}

output "logging_bucket_domain_name" {
  description = "DNS of the logging bucket if exists"
  value       = try(aws_s3_bucket.logging[0].bucket_domain_name, [])
}

output "logging_bucket_versioning_enabled" {
  description = "Is versioning enabled on the logging bucket if exists"
  value       = try(aws_s3_bucket.logging[0].versioning[0].enabled, [])
}

