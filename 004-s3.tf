resource "aws_kms_key" "s3_key" {
  description = "KMS key for S3 server-side encryption"
}

resource "aws_s3_bucket" "argo_s3_bucket" {
  bucket = "argo-example545-bucket"
    acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "argo_s3_ownership" {
  bucket = aws_s3_bucket.argo_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "argo_bucket_side_encryption_configuration" {
  bucket = aws_s3_bucket.argo_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "argo_bucket_lifecycle_configuration" {
  bucket = aws_s3_bucket.argo_s3_bucket.id
  rule {
    id      = "transition-to-ia"
    status  = "Enabled"
    filter {
      prefix = ""
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}
