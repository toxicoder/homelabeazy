# Makefile for homelab setup

# Default target
.DEFAULT_GOAL := help

# Variables
SHELL := /bin/bash
ANSIBLE_PLAYBOOK := ansible-playbook
TERRAFORM := terraform

# Targets
.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  setup                  - Run the setup script"
	@echo "  configure-proxmox      - Run the proxmox configuration script"
	@echo "  import                 - Run the import script"
	@echo "  terraform-apply        - Apply terraform configuration"
	@echo "  ansible-playbook-setup - Run the ansible setup playbook"

.PHONY: setup
setup:
	@echo "Running setup script..."
	@scripts/setup.sh

.PHONY: configure-proxmox
configure-proxmox:
	@echo "Running proxmox configuration script..."
	@scripts/configure_proxmox.sh

.PHONY: import
import:
	@echo "Running import script..."
	@scripts/import.sh

.PHONY: terraform-apply
terraform-apply:
	@echo "Applying terraform configuration..."
	$(TERRAFORM) -chdir=infrastructure/proxmox apply

.PHONY: terraform-destroy
terraform-destroy:
	@echo "Destroying terraform configuration..."
	$(TERRAFORM) -chdir=infrastructure/proxmox destroy

.PHONY: ansible-playbook-setup
ansible-playbook-setup:
	@echo "Running ansible setup playbook..."
	$(ANSIBLE_PLAYBOOK) ansible/playbooks/setup.yml
