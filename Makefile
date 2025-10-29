# Simple helpers to work with env stacks
# Usage:
#   make init ENV=dev
#   make plan ENV=prod VARS=custom.tfvars

ENV ?= dev
CHDIR = envs/$(ENV)
VARS ?= terraform.tfvars

init:
	terraform -chdir=$(CHDIR) init

plan:
	terraform -chdir=$(CHDIR) plan -var-file=$(VARS)

apply:
	terraform -chdir=$(CHDIR) apply -var-file=$(VARS) -auto-approve

destroy:
	terraform -chdir=$(CHDIR) destroy -var-file=$(VARS) -auto-approve

fmt:
	terraform -chdir=$(CHDIR) fmt -recursive

validate:
	terraform -chdir=$(CHDIR) validate
