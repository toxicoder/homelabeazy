#!/bin/bash

set -euo pipefail

# --- Constants ---
TERRAFORM_DIR="infrastructure/proxmox"
CONFIG_DIR="config"
CONFIG_EXAMPLE_DIR="config.example"
ANSIBLE_DIR="ansible"
ANSIBLE_PLAYBOOK="playbooks/main.yml"
ANSIBLE_INVENTORY="inventory/inventory.auto.yml"
STEALTH_VM_PLAYBOOK="stealth-vm/ansible/playbook.yml"

# --- Functions ---

# Cleanup function
cleanup() {
    echo "An error occurred. Cleaning up..."
    # Add cleanup commands here if needed
}

# Check for required commands
check_dependencies() {
    if ! command -v terraform &> /dev/null; then
        echo "Error: terraform could not be found"
        exit 1
    fi

    if ! command -v ansible-playbook &> /dev/null; then
        echo "ansible-playbook could not be found"
        exit 1
    fi
}

# Create configuration from examples
create_config() {
    if [ ! -d "$CONFIG_DIR" ]; then
        echo "Creating config directory..."
        cp -r "$CONFIG_EXAMPLE_DIR/" "$CONFIG_DIR/"
    fi
}

# Prompt for user input and create config files
prompt_for_input_and_create_configs() {
    # Prompt for Proxmox credentials
    read -p "Enter Proxmox API URL: " proxmox_api_url
    read -p "Enter Proxmox Token ID: " pm_token_id
    read -sp "Enter Proxmox Token Secret: " pm_token_secret
    echo

    # Create terraform.tfvars
    cat > "$TERRAFORM_DIR/terraform.tfvars" <<EOF
proxmox_api_url = "$proxmox_api_url"
pm_token_id     = "$pm_token_id"
pm_token_secret = "$pm_token_secret"
EOF

    # Prompt for domain name
    read -p "Enter your domain name (e.g., homelab.local): " domain_name
    sed -i "s/domain_name: .*/domain_name: $domain_name/" "$CONFIG_DIR/config.yml"
    sed -i "s/ldap_base_dn: .*/ldap_base_dn: dc=$(echo $domain_name | sed 's/\./,dc=/g')/" "$CONFIG_DIR/config.yml"

    # Prompt for stealth VM
    read -p "Enable stealth VM? (y/n): " enable_stealth_vm
    if [ "$enable_stealth_vm" == "y" ]; then
      read -p "Enter Windows ISO path: " windows_iso
      read -p "Enter GPU PCI ID: " gpu_pci_id
      read -p "Enter real MAC address: " real_mac
      read -p "Enter Proxmox host: " proxmox_host

      cat >> "$TERRAFORM_DIR/terraform.tfvars" <<EOF
stealth_vm_enabled     = "$enable_stealth_vm"
stealth_vm_windows_iso = "$windows_iso"
stealth_vm_gpu_pci_id  = "$gpu_pci_id"
stealth_vm_real_mac    = "$real_mac"
proxmox_node           = "$proxmox_host"
EOF
    fi
}

# Provision infrastructure with Terraform
provision_infrastructure() {
    echo "Running Terraform..."
    (cd "$TERRAFORM_DIR" && terraform init && terraform plan && terraform apply -auto-approve)
    echo "Terraform run successful."
}

# Configure cluster with Ansible
configure_cluster() {
    echo "Running Ansible..."
    if [ "$enable_stealth_vm" == "y" ]; then
        stealth_vm_ip=$(cd "$TERRAFORM_DIR" && terraform output -raw stealth_vm_ip)
        ansible-playbook -i "$ANSIBLE_DIR/$ANSIBLE_INVENTORY" "$STEALTH_VM_PLAYBOOK" --extra-vars "stealth_vm_ip=$stealth_vm_ip"
    fi
    ansible-playbook -i "$ANSIBLE_DIR/$ANSIBLE_INVENTORY" "$ANSIBLE_DIR/$ANSIBLE_PLAYBOOK"
    echo "Ansible run successful."
}

# --- Main ---
main() {
    trap cleanup ERR EXIT
    check_dependencies
    create_config
    prompt_for_input_and_create_configs
    provision_infrastructure
    configure_cluster
}

main "$@"
