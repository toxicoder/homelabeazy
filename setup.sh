#!/bin/bash

# This script will set up the homelab environment.

export PATH=$PATH:/home/jules/.local/bin:/usr/local/bin

# Export the variables from the config/main.yml file.
python3 config/export_vars.py
source .env

# Create the terraform.tfvars file.
cat > terraform/terraform.tfvars <<EOF
pm_api_url = "$PM_API_URL"
pm_token_id = "$PM_TOKEN_ID"
pm_token_secret = "$PM_TOKEN_SECRET"
EOF

cp *.tf terraform/

# Create the group_vars/all.yml file.
cat > ansible/group_vars/all.yml <<EOF
domain_name: $DOMAIN_NAME
EOF

# Run terraform init.
(cd terraform && terraform init)

# Run terraform plan.
(cd terraform && terraform plan)

# Run terraform apply.
(cd terraform && terraform apply -auto-approve)

# Run the ansible playbook.
ansible-playbook -i ansible/inventory/inventory.auto.yml ansible/playbooks/setup.yml
