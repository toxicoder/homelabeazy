.DEFAULT_GOAL := help

# ==============================================================================
# VARIABLES
# ==============================================================================

SHELL         := /bin/bash
PROJECT_NAME  := homelabeazy
PYTHON        := $(shell which python)
TERRAFORM_DIR := infrastructure/proxmox
ANSIBLE_DIR   := ansible
CONFIG_DIR    := private
CONFIG_EXAMPLE_DIR := config.example

# ==============================================================================
# COMMANDS
# ==============================================================================

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: install-deps
install-deps: ## Install dependencies
	@echo ">>> Installing Python dependencies..."
	@$(PYTHON) -m pip install -r requirements.txt

.PHONY: setup
setup: install-deps ## Run the interactive setup script for the homelab
	@echo ">>> Checking dependencies..."
	@if ! command -v terraform &> /dev/null; then \
		echo "Error: terraform could not be found"; \
		exit 1; \
	fi
	@if ! command -v ansible-playbook &> /dev/null; then \
		echo "ansible-playbook could not be found"; \
		exit 1; \
	fi
	@if ! command -v yq &> /dev/null; then \
		echo "yq could not be found. Please install yq: https://github.com/mikefarah/yq#install"; \
		exit 1; \
	fi
	@echo ">>> Creating private config directory..."
	@if [ ! -d "$(CONFIG_DIR)" ]; then \
		mkdir -p $(CONFIG_DIR); \
		cp -r "$(CONFIG_EXAMPLE_DIR)/." "$(CONFIG_DIR)/"; \
	fi
	@echo ">>> Prompting for input and creating configs..."
	@read -p "Enter Proxmox API URL: " proxmox_api_url; \
	read -p "Enter Proxmox Token ID: " pm_token_id; \
	read -sp "Enter Proxmox Token Secret: " pm_token_secret; \
	echo; \
	cat > "$(CONFIG_DIR)/terraform.tfvars" <<EOF; \
proxmox_api_url = "$$proxmox_api_url"
pm_token_id     = "$$pm_token_id"
pm_token_secret = "$$pm_token_secret"
EOF
	@read -p "Enter your domain name (e.g., homelab.local): " domain_name; \
	yq e '.common.domain_name = "'$$domain_name'"' -i "$(CONFIG_DIR)/config.yml"; \
	yq e '.common.ldap_base_dn = "dc='`echo $$domain_name | sed 's/\./,dc=/g'`'"' -i "$(CONFIG_DIR)/config.yml";
	@read -p "Enable stealth VM? (y/n): " enable_stealth_vm; \
	if [ "$$enable_stealth_vm" = "y" ]; then \
		read -p "Enter Windows ISO path: " windows_iso; \
		read -p "Enter GPU PCI ID: " gpu_pci_id; \
		read -p "Enter real MAC address: " real_mac; \
		read -p "Enter Proxmox host: " proxmox_host; \
		cat >> "$(TERRAFORM_DIR)/terraform.tfvars" <<EOF; \
stealth_vm_enabled     = "y"
stealth_vm_windows_iso = "$$windows_iso"
stealth_vm_gpu_pci_id  = "$$gpu_pci_id"
stealth_vm_real_mac    = "$$real_mac"
proxmox_node           = "$$proxmox_host"
EOF; \
	fi
	@echo ">>> Provisioning infrastructure with Terraform..."
	$(MAKE) terraform-apply
	@echo ">>> Generating Ansible inventory..."
	$(MAKE) inventory
	@echo ">>> Configuring cluster with Ansible..."
	$(MAKE) ansible-playbook-setup
	@if [ "$$enable_stealth_vm" = "y" ]; then \
		stealth_vm_ip=`cd "$(TERRAFORM_DIR)" && terraform output -raw stealth_vm_ip`; \
		cd $(ANSIBLE_DIR) && ansible-playbook stealth-vm/ansible/playbook.yml --extra-vars "stealth_vm_ip=$$stealth_vm_ip"; \
	fi

.PHONY: destroy
destroy: ## Destroy the infrastructure
	@echo ">>> Destroying Terraform infrastructure..."
	@cd $(TERRAFORM_DIR) && terraform destroy -auto-approve -var-file=../../$(CONFIG_DIR)/terraform.tfvars

.PHONY: lint
lint: lint-yaml lint-ansible lint-terraform ## Run all linters

.PHONY: lint-yaml
lint-yaml: ## Lint YAML files
	@echo ">>> Linting YAML files..."
	@yamllint .

.PHONY: lint-ansible
lint-ansible: ## Lint Ansible files
	@echo ">>> Linting Ansible files..."
	@ansible-lint

.PHONY: lint-terraform
lint-terraform: ## Lint Terraform files
	@echo ">>> Formatting and linting Terraform files..."
	@cd $(TERRAFORM_DIR) && terraform fmt -recursive && terraform validate

.PHONY: terraform-init
terraform-init: ## Initialize Terraform
	@echo ">>> Initializing Terraform..."
	@cd $(TERRAFORM_DIR) && terraform init

.PHONY: terraform-plan
terraform-plan: ## Plan the Terraform deployment
	@echo ">>> Planning Terraform deployment..."
	@cd $(TERRAFORM_DIR) && terraform plan -var-file=../../$(CONFIG_DIR)/terraform.tfvars

.PHONY: terraform-apply
terraform-apply: terraform-init ## Apply the Terraform deployment
	@echo ">>> Applying Terraform deployment..."
	@cd $(TERRAFORM_DIR) && terraform apply -auto-approve -var-file=../../$(CONFIG_DIR)/terraform.tfvars

.PHONY: inventory
inventory: ## Generate Ansible inventory file from Terraform outputs
	@echo ">>> Generating Ansible inventory..."
	@cd $(TERRAFORM_DIR) && terraform output -json | $(PYTHON) ../../scripts/generate_inventory.py

.PHONY: ansible-playbook-setup
ansible-playbook-setup: ## Run the main Ansible playbook for setup
	@echo ">>> Running main Ansible playbook..."
	@cd $(ANSIBLE_DIR) && ansible-playbook playbooks/main.yml -i inventory/inventory.auto.yml

.PHONY: test
test: ## Run Molecule tests for all Ansible roles
	@echo ">>> Running Molecule tests..."
	@cd ansible/roles && molecule test --all

.PHONY: clean
clean: ## Clean up temporary files
	@echo ">>> Cleaning up..."
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
