#!/bin/bash

# This script imports existing Proxmox resources into Terraform.
# Note: This script is an example. You will need to update the resource names
# and IDs to match your environment.

# Example for importing the k3s master node:
# terraform import module.k3s.proxmox_vm_qemu.k3s_master pve/qemu/100

# Example for importing a worker node:
# terraform import 'module.k3s.proxmox_vm_qemu.k3s_worker[0]' pve/qemu/101
