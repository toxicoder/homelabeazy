#!/bin/bash

# This script imports existing Proxmox resources into Terraform.

terraform import proxmox_vm_qemu.test_vm pve/qemu/100
terraform import proxmox_lxc.test_lxc pve/lxc/101
