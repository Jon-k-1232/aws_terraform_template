############################################
# Variables (inputs)
# Docs:
# - Input Variables: https://developer.hashicorp.com/terraform/language/values/variables
############################################

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Default AWS region."
  type        = string
  default     = "us-east-1"
}

variable "naming_prefix" {
  description = "Optional naming prefix for resources. Defaults to var.environment if empty."
  type        = string
  default     = ""
}

variable "additional_tags" {
  description = "Additional tags applied to resources (merged with defaults)."
  type        = map(string)
  default     = {}
}

# Network
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the (public) subnet."
  type        = string
  default     = "10.10.0.0/24"
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to access SSH on instances associated with the example SG."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Storage
variable "s3_bucket_name" {
  description = "Optional bucket name override. If empty, a name will be generated."
  type        = string
  default     = ""
}

variable "s3_force_destroy" {
  description = "Whether to allow deleting bucket with objects."
  type        = bool
  default     = false
}

# IAM
variable "iam_role_name" {
  description = "Base name for the IAM role."
  type        = string
  default     = "app-role"
}

variable "iam_role_trust_service" {
  description = "Service principal for assume role policy (e.g., ec2.amazonaws.com, lambda.amazonaws.com)."
  type        = string
  default     = "ec2.amazonaws.com"
}

variable "iam_role_policy_arns" {
  description = "List of managed policy ARNs to attach to the IAM role."
  type        = list(string)
  default     = []
}

# Secrets (Secrets Manager)
variable "secrets" {
  description = "Map of secret_name => secret_value to create in Secrets Manager (sensitive)."
  type        = map(string)
  default     = {}
  sensitive   = true
}
