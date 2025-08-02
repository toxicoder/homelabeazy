#!/bin/bash

set -eu

# Check for required commands
if ! command -v terraform &> /dev/null; then
    echo "terraform could not be found"
    exit 1
fi

if ! command -v ansible-playbook &> /dev/null; then
    echo "ansible-playbook could not be found"
    exit 1
fi

# This script will set up the homelab environment.

# -----------------
# --- VARIABLES ---
# -----------------

export PATH=$PATH:/home/jules/.local/bin:/usr/local/bin

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
  ansible-playbook -i ansible/inventory/inventory.auto.yml stealth-vm/ansible/playbook.yml --extra-vars "stealth_vm_ip=$stealth_vm_ip"
fi

# Run the ansible playbook.
ansible-playbook -i ansible/inventory/inventory.auto.yml ansible/playbooks/setup.yml
