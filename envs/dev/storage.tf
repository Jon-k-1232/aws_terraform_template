############################################
# Storage (S3)
# Docs:
# - Bucket:                 https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
# - Versioning:             https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning
# - Lifecycle Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
# - Random ID:              https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id
############################################

resource "random_id" "bucket_suffix" {
  byte_length = 2
}

locals {
  bucket_name = var.s3_bucket_name != "" ? var.s3_bucket_name : "${local.naming_prefix}-artifacts-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket" "artifacts" {
  bucket        = local.bucket_name
  force_destroy = var.s3_force_destroy

  tags = local.common_tags
}

# Enable versioning
resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Example: Server-side encryption with a customer-managed KMS key (SSE-KMS)
# Docs:
# - Terraform SSE config: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration
# - AWS S3 SSE:           https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html
#
# Uncomment and set your KMS key ARN to enforce SSE-KMS on the bucket.
# resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
#   bucket = aws_s3_bucket.artifacts.id
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = "aws:kms"
#       kms_master_key_id = "arn:aws:kms:<region>:<account-id>:key/<key-id>"
#     }
#   }
# }

# Keep lifecycle lean: expire noncurrent versions after 30 days to control costs.
resource "aws_s3_bucket_lifecycle_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    id     = "expire-noncurrent-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}
