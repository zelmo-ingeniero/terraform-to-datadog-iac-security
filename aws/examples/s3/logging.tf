
resource "aws_s3_bucket" "logging" {
  count = var.logging != "" ? 1 : 0

  bucket        = var.logging
  force_destroy = true

  tags = {
    Name = var.logging
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

resource "aws_s3_bucket_versioning" "logging" {
  count = length(aws_s3_bucket.logging)

  bucket = aws_s3_bucket.logging[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  count = length(aws_s3_bucket.logging)

  bucket = aws_s3_bucket.logging[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" // "aws:kms" or "aws:kms:dsse"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "logging" {
  count = length(aws_s3_bucket.logging)

  bucket = aws_s3_bucket.logging[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "logging" {
  count = length(aws_s3_bucket.logging)

  bucket     = aws_s3_bucket.logging[0].id
  acl        = "log-delivery-write"
  depends_on = [aws_s3_bucket_ownership_controls.logging]
}

resource "aws_s3_bucket_public_access_block" "logging" {
  count = length(aws_s3_bucket.logging)

  bucket                  = aws_s3_bucket.logging[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

