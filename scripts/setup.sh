#!/bin/bash

set -euo pipefail

# --- Cleanup function ---
cleanup() {
    echo "An error occurred. Cleaning up..."
    # Add cleanup commands here if needed
}

trap cleanup ERR EXIT

# Check for required commands
if ! command -v terraform &> /dev/null; then
    echo "Error: terraform could not be found"
    exit 1
fi

if ! command -v ansible-playbook &> /dev/null; then
    echo "ansible-playbook could not be found"
    exit 1
fi

# This script will set up the homelab environment.

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
# --- FUNCTIONS --
# ----------------

run_terraform() {
    echo "Running Terraform..."
    (cd infrastructure/proxmox && terraform init && terraform plan && terraform apply -auto-approve)
    echo "Terraform run successful."
}

run_ansible() {
    echo "Running Ansible..."
    if [ "$enable_stealth_vm" == "y" ]; then
        stealth_vm_ip=$(cd infrastructure/proxmox && terraform output -raw stealth_vm_ip)
        ansible-playbook -i ansible/inventory/inventory.auto.yml stealth-vm/ansible/playbook.yml --extra-vars "stealth_vm_ip=$stealth_vm_ip"
    fi
    ansible-playbook -i ansible/inventory/inventory.auto.yml ansible/playbooks/setup.yml
    echo "Ansible run successful."
}

# ----------------
# --- MAIN -------
# ----------------

run_terraform
run_ansible
