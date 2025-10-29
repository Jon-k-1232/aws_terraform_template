############################################
# Secrets Manager
# Docs:
# - Secret:         https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret
# - Secret Version: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version
# - Data source:    https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret
############################################

# Create secrets for each map entry. Values are sensitive.
resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secrets

  name = "${local.naming_prefix}-${each.key}"
  # To use a customer-managed KMS key (CMK) for encryption instead of the default AWS managed key,
  # uncomment kms_key_id below and set it to your KMS key ARN.
  # kms_key_id = "arn:aws:kms:<region>:<account-id>:key/<key-id>"
  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "secrets" {
  for_each = var.secrets

  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value
}

# Example: To read a secret value in Terraform, you could use a data source.
# NOTE: Delete or adjust the example below if you do not have a key of "example" in var.secrets.
# data "aws_secretsmanager_secret" "example" {
#   name = aws_secretsmanager_secret.secrets["example"].name
# }
# output "example_secret_name" {
#   value     = data.aws_secretsmanager_secret.example.name
# }
