# Resource documentation and common properties

This sheet links to the official Terraform docs and highlights common arguments/attributes you’ll likely reference during an interview.

## Providers and settings

-  AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
-  Terraform settings (cloud): https://developer.hashicorp.com/terraform/language/settings/cloud

General Terraform references:

-  Terraform language overview: https://developer.hashicorp.com/terraform/language
-  Configuration syntax (blocks): https://developer.hashicorp.com/terraform/language/syntax/configuration
-  Terraform Registry (search resources): https://registry.terraform.io/
-  Variables: https://developer.hashicorp.com/terraform/language/values/variables
-  Outputs: https://developer.hashicorp.com/terraform/language/values/outputs

AWS IAM reference:

-  AWS IAM policies and permissions: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
-  AWS managed policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html

Provider arguments commonly used:

-  `region` – default region for resources
-  `profile` – named profile for auth (optional)
-  `default_tags` – tags to apply to all resources that support tagging

## Network

-  VPC: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
   -  `cidr_block`, `enable_dns_hostnames`, `enable_dns_support`, `tags`
   -  AWS docs: https://docs.aws.amazon.com/vpc/
-  Subnet: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
   -  `vpc_id`, `cidr_block`, `availability_zone`, `map_public_ip_on_launch`
-  Internet Gateway: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
-  Route Table: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
-  Route Table Association: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
-  Security Group: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
   -  `ingress`/`egress` rules, `vpc_id`, `description`

## Storage (S3)

-  S3 Bucket: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
   -  `bucket`, `force_destroy`, `tags`
-  Versioning: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning
-  Lifecycle Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
-  Bucket Policy (optional): https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy

## IAM

-  IAM Role: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
   -  `name`, `assume_role_policy`, `tags`
-  IAM Role Policy Attachment: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
   -  `role`, `policy_arn`
-  IAM Policy (custom, optional): https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy

## Secrets Manager

-  Secret: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret
   -  `name`, `kms_key_id` (optional), `tags`
-  Secret Version: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version
   -  `secret_id`, `secret_string`
-  Data Source: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret

## Patterns and tips

-  Keep environment-specific state by putting a `cloud {}` block in each env folder and unique workspace names.
-  Use `TF_VAR_...` env vars for secrets. Avoid committing secrets in `.tfvars`.
-  Prefer default tags in the provider for consistent inventory/cost attribution.
-  Use `for_each` with maps/lists to express sets of IAM attachments or secrets cleanly.
