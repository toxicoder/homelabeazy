#!/bin/bash

# This script will set up the homelab environment.

# Ask for the user's Proxmox API URL.
read -p "Enter your Proxmox API URL: " pm_api_url

# Ask for the user's Proxmox API token ID.
read -p "Enter your Proxmox API token ID: " pm_token_id

# Ask for the user's Proxmox API token secret.
read -sp "Enter your Proxmox API token secret: " pm_token_secret
echo

# Ask for the user's domain name.
read -p "Enter your domain name: " domain_name

# Create the terraform.tfvars file.
cat > terraform/terraform.tfvars <<EOF
pm_api_url = "$pm_api_url"
pm_token_id = "$pm_token_id"
pm_token_secret = "$pm_token_secret"
EOF

# Create the group_vars/all.yml file.
cat > ansible/group_vars/all.yml <<EOF
domain_name: $domain_name
EOF

# Run terraform init.
terraform -chdir=terraform init

# Run terraform plan.
terraform -chdir=terraform plan

# Run terraform apply.
terraform -chdir=terraform apply -auto-approve

# Run the ansible playbook.
ansible-playbook -i ansible/inventory/inventory.auto.yml ansible/playbooks/setup.yml
