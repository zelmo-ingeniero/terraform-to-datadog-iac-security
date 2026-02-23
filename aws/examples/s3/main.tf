
locals {
  object-lock-buckets = compact([for v in keys(var.buckets) :
    contains(var.buckets[v], "versioning") ? v : ""
  ])
  logging-buckets = compact([for l in keys(var.buckets) :
    contains(var.buckets[l], "logging") ? l : ""
  ])
}

resource "aws_s3_bucket" "this" {
  for_each = var.buckets

  bucket        = each.key
  force_destroy = true
  tags = {
    Name = each.key
  }
}

resource "aws_s3_bucket_logging" "this" {
  for_each = toset(local.logging-buckets)

  bucket        = each.key
  target_bucket = aws_s3_bucket.logging[0].id
  target_prefix = "${each.key}/"
  lifecycle {
    precondition {
      condition     = length(var.logging) > 0
      error_message = "Bad call to module | To use logging is required a logging bucket name"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" // "aws:kms" or "aws:kms:dsse"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  for_each = toset(local.object-lock-buckets)

  bucket = each.key
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  for_each = toset(local.object-lock-buckets)

  bucket     = each.key
  depends_on = [aws_s3_bucket_versioning.this]
}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each                = var.buckets
  bucket                  = aws_s3_bucket.this[each.key].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# disabled by default
# resource "aws_s3_bucket_acl" "acl" {
#   for_each   = var.buckets
#   bucket     = aws_s3_bucket.this[each.key].id
#   acl        = "private"
#   depends_on = [aws_s3_bucket_ownership_controls.acl]
# }


# resource "aws_s3_bucket_policy" "pci_dss_bucket_policy" {
#   bucket = aws_s3_bucket.pci_dss_bucket.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Deny"
#         Principal = "*"
#         Action = "s3:*"
#         Resource = [
#           "arn:aws:s3:::${aws_s3_bucket.pci_dss_bucket.bucket}",
#           "arn:aws:s3:::${aws_s3_bucket.pci_dss_bucket.bucket}/*"
#         ]
#         Condition = {
#           Bool = {
#             "aws:SecureTransport" = "false"
#           }
#         }
#       }
#     ]
#   })
# }
