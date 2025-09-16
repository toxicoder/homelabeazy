---
title: Advanced Usage
parent: Guides
---

# Advanced Usage

This project includes a `Makefile` that provides a convenient way to run common tasks. This guide will walk you through some of the more advanced features of Homelabeazy.

## Makefile Commands

The `Makefile` at the root of the project provides a number of helpful commands for managing your homelab. Here are some of the most common ones:

-   **`make help`**: Display a list of all available commands.
-   **`make install-deps`**: Install all the necessary dependencies for the project.
-   **`make setup-interactive`**: Run the interactive setup script to configure your homelab.
-   **`make lint`**: Run all the linters to check your code for errors.
-   **`make terraform-apply`**: Apply the Terraform configuration to provision your infrastructure.
-   **`make ansible-playbook-setup`**: Run the main Ansible playbook to configure your cluster and deploy your applications.
-   **`make test`**: Run the test suite for the project.
-   **`make clean`**: Clean up any temporary files.

## Homelab Importer

If you have an existing homelab that was configured manually, you can use the `homelab-importer` tool to import it into a Terraform-managed setup. This is a great way to migrate your existing homelab to the Infrastructure as Code (IaC) approach used by this project.

For detailed instructions on how to use the importer, please see the [Technical Design]({% link docs/reference/technical-design.md %}) guide.

## OpenLDAP

This project includes an Ansible role for deploying OpenLDAP to your Kubernetes cluster. OpenLDAP is used as the central user directory for your homelab, and it is integrated with Authelia to provide Single Sign-On (SSO) for your applications.

The OpenLDAP passwords are managed by Vault. You will need to add the following secrets to Vault at the path `secrets/data/openldap`:

-   `root-password`
-   `admin-password`

## Stealth VM

This project includes an optional "stealth" Windows VM on Proxmox. The purpose of this VM is to allow for game streaming from a server. It aims to provide a normal gaming environment, which can sometimes be challenging on virtualized hardware.

### Our Stance on Cheating

**This project is firmly against cheating in any form.** The "stealth" features are designed to make the virtual machine appear as a standard physical machine to the game, ensuring compatibility and performance. It is **not** intended to enable or facilitate cheating. We believe in fair play and sportsmanship. Any use of this project for activities that violate the terms of service of a game, including cheating, is strictly discouraged.

### Prerequisites

-   Proxmox 8.x+
-   A Windows ISO file
-   The PCI ID of the GPU you want to pass through
-   The MAC address of your physical network card

### Usage

To enable the stealth VM, run the `scripts/setup.sh` script and answer "y" when prompted to enable the stealth VM. You will then be prompted for the Windows ISO path, GPU PCI ID, and real MAC address.

### Disclaimer

This feature is intended for running games on a virtual machine for streaming purposes. Using this for any form of cheating is against the principles of this project. The author of this project is not responsible for any consequences that may arise from the misuse of this feature.
