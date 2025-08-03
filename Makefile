.DEFAULT_GOAL := help

# ==============================================================================
# VARIABLES
# ==============================================================================

SHELL         := /bin/bash
PROJECT_NAME  := homelabeazy
PYTHON        := $(shell which python)
TERRAFORM_DIR := infrastructure/proxmox
ANSIBLE_DIR   := ansible

# ==============================================================================
# COMMANDS
# ==============================================================================

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: install-deps
install-deps: ## Install dependencies and setup pre-commit
	@echo ">>> Installing Python dependencies with Pipenv..."
	@pipenv install --dev
	@echo ">>> Skipping pre-commit hook installation..."
	# @pipenv run pre-commit install

.PHONY: setup-homelab
setup-homelab: ## Run the interactive setup script for the homelab
	@./scripts/setup.sh

.PHONY: lint
lint: lint-yaml lint-ansible lint-terraform ## Run all linters

.PHONY: lint-yaml
lint-yaml: ## Lint YAML files
	@echo ">>> Linting YAML files..."
	@pipenv run yamllint .

.PHONY: lint-ansible
lint-ansible: ## Lint Ansible files
	@echo ">>> Linting Ansible files..."
	@pipenv run ansible-lint

.PHONY: lint-terraform
lint-terraform: ## Lint Terraform files
	@echo ">>> Formatting and linting Terraform files..."
	@cd $(TERRAFORM_DIR) && pipenv run terraform fmt -recursive && pipenv run terraform validate

.PHONY: terraform-init
terraform-init: ## Initialize Terraform
	@echo ">>> Initializing Terraform..."
	@cd $(TERRAFORM_DIR) && pipenv run terraform init

.PHONY: terraform-plan
terraform-plan: ## Plan the Terraform deployment
	@echo ">>> Planning Terraform deployment..."
	@cd $(TERRAFORM_DIR) && pipenv run terraform plan

.PHONY: terraform-apply
terraform-apply: ## Apply the Terraform deployment
	@echo ">>> Applying Terraform deployment..."
	@cd $(TERRAFORM_DIR) && pipenv run terraform apply -auto-approve

.PHONY: ansible-playbook-main
ansible-playbook-main: ## Run the main Ansible playbook
	@echo ">>> Running main Ansible playbook..."
	@cd $(ANSIBLE_DIR) && pipenv run ansible-playbook playbooks/main.yml -i inventory/inventory.auto.yml

.PHONY: test
test: ## Run Molecule tests for all Ansible roles
	@echo ">>> Running Molecule tests..."
	@cd ansible/roles && pipenv run molecule test --all

.PHONY: clean
clean: ## Clean up temporary files
	@echo ">>> Cleaning up..."
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
