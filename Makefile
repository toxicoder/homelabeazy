.DEFAULT_GOAL := help

# ==============================================================================
# VARIABLES
# ==============================================================================

SHELL         := /bin/bash
PROJECT_NAME  := homelabeazy
PYTHON        := $(shell which python)

# ==============================================================================
# COMMANDS
# ==============================================================================

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## Install dependencies and setup pre-commit
	@echo ">>> Installing Python dependencies with Pipenv..."
	@pipenv install --dev
	@echo ">>> Installing pre-commit hooks..."
	@pipenv run pre-commit install

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
	@cd infrastructure/proxmox && pipenv run terraform fmt -recursive && pipenv run terraform validate

.PHONY: test
test: ## Run Molecule tests for all Ansible roles
	@echo ">>> Running Molecule tests..."
	@cd ansible/roles && pipenv run molecule test --all

.PHONY: clean
clean: ## Clean up temporary files
	@echo ">>> Cleaning up..."
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
