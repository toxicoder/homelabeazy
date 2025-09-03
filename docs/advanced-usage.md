# Usage

This project includes a `Makefile` that provides a convenient way to run common tasks.

## Makefile Commands

  - **`make help`**: Display a list of available commands.
  - **`make install-deps`**: Install dependencies.
  - **`make setup`**: Run the interactive setup script for the homelab. **(Not Recommended)**
  - **`make lint`**: Run all linters.
  - **`make terraform-init`**: Initialize Terraform.
  - **`make terraform-plan`**: Plan the Terraform deployment.
  - **`make terraform-apply`**: Apply the Terraform deployment.
  - **`make ansible-playbook-setup`**: Run the main Ansible playbook for setup.
  - **`make test`**: Run Molecule tests for all Ansible roles.
  - **`make clean`**: Clean up temporary files.

# Testing

Some parts of this project have tests, but the overall testing framework is still under development. You can run the available tests with:

```bash
make test
```

# Homelab Importer

This repository includes a tool to import an existing, manually-configured Proxmox environment into a Terraform-managed setup. This is useful for migrating your existing homelab to this project's infrastructure as code approach.

For detailed instructions on how to use the importer, please see the [Homelab Importer README](tools/homelab-importer/README.md).

# OpenLDAP

This repository includes an Ansible role for deploying OpenLDAP to the Kubernetes cluster. The role can be found in `ansible/roles/openldap`.

## Configuration

The OpenLDAP role uses the following variables for configuration:

  - `openldap_root_password`: The password for the OpenLDAP root user.
  - `openldap_admin_password`: The password for the OpenLDAP admin user.

These variables should be set as environment variables before running the Ansible playbook:

```bash
export OPENLDAP_ROOT_PASSWORD="your-root-password"
export OPENLDAP_ADMIN_PASSWORD="your-admin-password"
```

The OpenLDAP application is deployed using the `apps/openldap.yml` manifest. The passwords for the OpenLDAP users are managed by Vault. You will need to add the following secrets to Vault:

  - `secrets/data/openldap`
      - `root-password`
      - `admin-password`

# Stealth VM

This project includes an optional "stealth" Windows VM on Proxmox. The purpose of this VM is to allow for game streaming from a server. It aims to provide a normal gaming environment, which can sometimes be challenging on virtualized hardware.

## Our Stance on Cheating

**This project is firmly against cheating in any form.** The "stealth" features are designed to make the virtual machine appear as a standard physical machine to the game, ensuring compatibility and performance. It is **not** intended to enable or facilitate cheating. We believe in fair play and sportsmanship. Any use of this project for activities that violate the terms of service of a game, including cheating, is strictly discouraged.

## Prerequisites

  - Proxmox 8.x+
  - A Windows ISO file
  - The PCI ID of the GPU you want to pass through
  - The MAC address of your physical network card

## Usage

To enable the stealth VM, run the `scripts/setup.sh` script and answer "y" when prompted to enable the stealth VM. You will then be prompted for the Windows ISO path, GPU PCI ID, and real MAC address.

## Disclaimer

This feature is intended for running games on a virtual machine for streaming purposes. Using this for any form of cheating is against the principles of this project. The author of this project is not responsible for any consequences that may arise from the misuse of this feature.
