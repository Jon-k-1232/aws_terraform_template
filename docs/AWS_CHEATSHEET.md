# AWS products cheat sheet (AI platform engineer edition)

Use this as a fast lookup when choosing services and composing Terraform in interviews or sprints. It includes "when to use", common gotchas, IAM roles, and Terraform links.

## How to choose quickly

-  Stateless containers: App Runner (simplest) → ECS on Fargate (serverless) → EKS (Kubernetes)
-  Serverless compute / APIs: Lambda + API Gateway
-  Batch/ETL: AWS Batch → Glue (ETL) → EMR (Spark) → Step Functions (orchestrate) → Lambda for small jobs
-  Data warehouse/analytics: Redshift; lake in S3, query via Athena; streaming with Kinesis/MSK
-  Eventing: EventBridge for events; SQS for queues; SNS for pub/sub fan-out
-  Models: Bedrock (foundation models) + SageMaker (train, tune, deploy, pipelines, feature store)
-  Artifact storage: ECR (images), S3 (models/artifacts)
-  CI/CD: CodeBuild + CodePipeline (or GitHub Actions), CodeDeploy for EC2/ECS/Lambda
-  Security: IAM least privilege, Secrets Manager, KMS CMKs, VPC endpoints, SCPs with AWS Organizations

## Core building blocks

-  Accounts/OUs/Orgs: guardrails via SCPs, centralized identity via IAM Identity Center (SSO)
-  Networking: VPC, subnets, route tables, NAT, IGW, NLB/ALB, VPC endpoints (PrivateLink)
-  Identity: IAM roles, managed policies, role assumption, OIDC for GitHub Actions
-  State/config: Secrets Manager, SSM Parameter Store, KMS, Terraform Cloud/CloudFormation

## AI/ML

-  Amazon Bedrock: https://aws.amazon.com/bedrock/
   -  Use for: access to foundation models (chat, embeddings, image); guardrails, evaluations
   -  Gotchas: region/model availability, invoke quotas, cost by token/images
   -  IAM: bedrock:InvokeModel; control via identity-based or resource policies
-  SageMaker: https://aws.amazon.com/sagemaker/
   -  Use for: end-to-end ML (training, tuning, hosting, pipelines, notebooks, feature store)
   -  Gotchas: networking to S3/ECR (VPC endpoints), instance quotas, model registry flows
   -  Terraform: `aws_sagemaker_*` resources: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_domain
-  Feature Store: https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store.html
-  EMR (Spark): https://aws.amazon.com/emr/
-  Glue (ETL): https://aws.amazon.com/glue/

## Data platform

-  S3: https://aws.amazon.com/s3/
   -  Use for: data lake, artifacts, model storage; encrypt with KMS; lifecycle to control costs
   -  Terraform: bucket https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
-  Athena: https://aws.amazon.com/athena/
   -  Use for: SQL on S3; integrate with Glue Data Catalog
-  Redshift: https://aws.amazon.com/redshift/
-  Kinesis: https://aws.amazon.com/kinesis/; MSK (Managed Kafka): https://aws.amazon.com/msk/
-  DynamoDB: https://aws.amazon.com/dynamodb/

## Compute and containers

-  App Runner: https://aws.amazon.com/apprunner/
-  ECS + Fargate: https://aws.amazon.com/ecs/
-  EKS: https://aws.amazon.com/eks/
-  Lambda: https://aws.amazon.com/lambda/

## DevOps and supply chain

-  ECR: https://aws.amazon.com/ecr/
-  CodeBuild: https://aws.amazon.com/codebuild/
-  CodePipeline: https://aws.amazon.com/codepipeline/
-  CodeDeploy: https://aws.amazon.com/codedeploy/
-  GitHub Actions OIDC to assume roles: https://docs.github.com/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect

## Networking and security

-  VPC: https://aws.amazon.com/vpc/
-  ALB/NLB: https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/what-is-load-balancing.html
-  NAT Gateway: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
-  VPC endpoints/PrivateLink: https://docs.aws.amazon.com/vpc/latest/privatelink/endpoint-services-overview.html
-  IAM: https://docs.aws.amazon.com/iam/
-  Secrets Manager: https://aws.amazon.com/secrets-manager/
-  KMS: https://aws.amazon.com/kms/

## Observability

-  CloudWatch (Logs, Metrics, Alarms): https://aws.amazon.com/cloudwatch/
-  CloudTrail: https://aws.amazon.com/cloudtrail/
-  X-Ray (tracing): https://aws.amazon.com/xray/

## IAM roles quick picks (by task)

-  Deploy to ECS/Lambda: `iam:PassRole` on the task/execution role; attach `AmazonECSTaskExecutionRolePolicy` for ECS
-  Manage S3 artifacts: `AmazonS3ReadOnlyAccess` (read) or scoped-down bucket policies
-  Manage secrets: `SecretsManagerReadWrite` for admin; runtime `secretsmanager:GetSecretValue`
-  ECR push/pull: `AmazonEC2ContainerRegistryPowerUser` (build) or scoped `ecr:*` on repos

## Common quotas and limits to watch

-  Lambda concurrency and payload size/timeouts
-  Kinesis shard throughput
-  S3 request and prefix performance (use partitioning)
-  Bedrock/SageMaker regional service quotas and GPU availability
