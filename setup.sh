#!/bin/bash

# This script will set up the homelab environment.

# -----------------
# --- VARIABLES ---
# -----------------

export PATH=$PATH:/home/jules/.local/bin:/usr/local/bin

# Export the variables from the config/main.yml file.
python3 config/export_vars.py
source .env

# ------------------
# --- STEALTH VM ---
# ------------------

# Prompt for stealth VM
read -p "Enable stealth VM? (y/n): " enable_stealth_vm
if [ "$enable_stealth_vm" == "y" ]; then
  read -p "Enter Windows ISO path: " windows_iso
  read -p "Enter GPU PCI ID: " gpu_pci_id
  read -p "Enter real MAC address: " real_mac
  read -p "Enter Proxmox host: " proxmox_host
fi

# ----------------
# --- TERRAFORM --
# ----------------

# Create the terraform.tfvars file.
cat > homelab-infra/terraform.tfvars <<EOF
pm_api_url = "$PM_API_URL"
pm_token_id = "$PM_TOKEN_ID"
pm_token_secret = "$PM_TOKEN_SECRET"
enable_stealth_vm = ${enable_stealth_vm:-false}
windows_iso = "${windows_iso:-}"
gpu_pci_id = "${gpu_pci_id:-}"
real_mac = "${real_mac:-}"
proxmox_host = "${proxmox_host:-}"
EOF

# Create the group_vars/all.yml file.
cat > ansible/group_vars/all.yml <<EOF
domain_name: $DOMAIN_NAME
EOF

# Run terraform init.
(cd homelab-infra && terraform init)

# Run terraform plan.
(cd homelab-infra && terraform plan)

# Run terraform apply.
(cd homelab-infra && terraform apply -auto-approve)

# ----------------
# --- ANSIBLE ----
# ----------------

# Get the stealth VM IP
if [ "$enable_stealth_vm" == "y" ]; then
  stealth_vm_ip=$(cd homelab-infra && terraform output -raw stealth_vm_ip)
  echo "stealth_vm_ip: $stealth_vm_ip" >> ansible/group_vars/all.yml
  ansible-playbook -i ansible/inventory/inventory.auto.yml stealth-vm/ansible/playbook.yml
fi

# Run the ansible playbook.
ansible-playbook -i ansible/inventory/inventory.auto.yml ansible/playbooks/setup.yml
