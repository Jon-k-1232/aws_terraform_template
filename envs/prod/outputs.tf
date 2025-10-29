############################################
# Outputs
# Docs: https://developer.hashicorp.com/terraform/language/values/outputs
############################################

output "region" {
  description = "AWS region"
  value       = var.region
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public.id
}

output "bucket_name" {
  description = "Artifacts bucket name"
  value       = aws_s3_bucket.artifacts.bucket
}

output "iam_role_arn" {
  description = "App IAM role ARN"
  value       = aws_iam_role.app.arn
}
