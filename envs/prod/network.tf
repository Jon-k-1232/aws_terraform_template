############################################
# Network resources
# Docs:
# - VPC:               https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# - Subnet:            https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# - Internet Gateway:  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# - Route Table:       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# - RT Association:    https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
# - Security Group:    https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
############################################

# Single VPC with one public subnet as a minimal baseline.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${local.naming_prefix}-vpc"
  })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.naming_prefix}-subnet-public"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags, {
    Name = "${local.naming_prefix}-igw"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.naming_prefix}-rt-public"
  })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security group with egress-all and example SSH ingress.
resource "aws_security_group" "default" {
  name        = "${local.naming_prefix}-sg"
  description = "Baseline SG with egress-all and example SSH ingress"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Example ingress SSH rule — for demos only. Tighten or remove in practice.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
    description = "SSH from allowed CIDRs"
  }

  tags = merge(local.common_tags, {
    Name = "${local.naming_prefix}-sg"
  })
}

# Examples: VPC Endpoints for S3 (Gateway) and Secrets Manager (Interface)
# Docs:
# - Terraform VPC Endpoint: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint
# - AWS VPC endpoints:      https://docs.aws.amazon.com/vpc/latest/privatelink/endpoint-services-overview.html
#
# 1) S3 Gateway endpoint (routes to S3 via route table, keep traffic inside AWS network)
# resource "aws_vpc_endpoint" "s3_gateway" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.${var.region}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids   = [aws_route_table.public.id]
#   tags = merge(local.common_tags, { Name = "${local.naming_prefix}-vpce-s3" })
# }
#
# 2) Secrets Manager Interface endpoint (ENIs in subnets, SG required, Private DNS recommended)
# resource "aws_vpc_endpoint" "secrets_interface" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.${var.region}.secretsmanager"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [aws_subnet.public.id]
#   security_group_ids  = [aws_security_group.default.id]
#   private_dns_enabled = true
#   tags = merge(local.common_tags, { Name = "${local.naming_prefix}-vpce-secrets" })
# }
