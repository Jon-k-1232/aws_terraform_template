############################################
# IAM resources
# Docs:
# - IAM Role:                  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# - Role Policy Attachment:    https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
############################################

# Simple IAM role for app workloads. Default trust is EC2; adjust for Lambda/ECS/EKS as needed.
resource "aws_iam_role" "app" {
  name = "${local.naming_prefix}-${var.iam_role_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = var.iam_role_trust_service
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

# Optionally attach AWS-managed or customer-managed policies to the role.
resource "aws_iam_role_policy_attachment" "attachments" {
  for_each = toset(var.iam_role_policy_arns)

  role       = aws_iam_role.app.name
  policy_arn = each.value
}

# Examples: Attach managed policies or add a custom inline policy
# Docs:
# - AWS managed policies list: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
# - Terraform IAM Policy:     https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
# - Role Policy Attachment:   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
#
# 1) Add AWS-managed policies (Bedrock/SageMaker) via variable in terraform.tfvars
# iam_role_policy_arns = [
#   "arn:aws:iam::aws:policy/AmazonBedrockFullAccess",
#   "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
# ]
#
# 2) Create a scoped custom policy and attach it
# resource "aws_iam_policy" "app_extra" {
#   name   = "${local.naming_prefix}-app-extra"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect   = "Allow",
#         Action   = ["s3:GetObject"],
#         Resource = ["${aws_s3_bucket.artifacts.arn}/*"]
#       }
#     ]
#   })
# }
#
# resource "aws_iam_role_policy_attachment" "app_extra_attach" {
#   role       = aws_iam_role.app.name
#   policy_arn = aws_iam_policy.app_extra.arn
# }
