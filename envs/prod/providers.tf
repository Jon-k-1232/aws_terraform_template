############################################
# Provider and common locals
# Docs:
# - AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
#
# Provider sets the default region. Use default_tags to ensure consistent tagging.
############################################

provider "aws" {
  region = var.region

  # Apply common tags to all taggable resources
  default_tags {
    tags = merge({
      environment = var.environment
      managed_by  = "terraform"
    }, var.additional_tags)
  }
}

locals {
  # Consistent naming prefix. If not provided, use <env>.
  naming_prefix = var.naming_prefix != "" ? var.naming_prefix : var.environment

  # Common tags mirrored outside of provider.default_tags for places that need explicit maps
  common_tags = merge({
    environment = var.environment
    managed_by  = "terraform"
  }, var.additional_tags)
}
