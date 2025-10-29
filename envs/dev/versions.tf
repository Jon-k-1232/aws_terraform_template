terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  # Terraform Cloud state backend
  # IMPORTANT: Replace organization and workspace name below per environment
  cloud {
    organization = "CHANGE_ME_TFC_ORG"
    workspaces {
      name = "aws-ai-platform-dev"
    }
  }
}
