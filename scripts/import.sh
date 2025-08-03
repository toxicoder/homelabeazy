#!/bin/bash

# This script provides examples for importing existing Proxmox resources into Terraform.
#
# Usage:
# 1. Update the resource names and IDs in the commands below to match your environment.
# 2. Run the commands one by one.
#
# For example, to import the k3s master node with ID 100 on the pve node:
# ./scripts/import.sh master pve 100
#
# To import the first worker node with ID 101 on the pve node:
# ./scripts/import.sh worker 0 pve 101

set -e

if ! command -v terraform &> /dev/null
then
    echo "terraform could not be found. Please install it first."
    exit 1
fi

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <master|worker> [worker_index] <proxmox_node> <vm_id>"
    exit 1
fi

RESOURCE_TYPE=$1
PROXMOX_NODE=$2
VM_ID=$3

if [ "$RESOURCE_TYPE" == "master" ]; then
    terraform import module.k3s-cluster.module.k3s-master.proxmox_vm_qemu.node "${PROXMOX_NODE}/qemu/${VM_ID}"
elif [ "$RESOURCE_TYPE" == "worker" ]; then
    if [ "$#" -ne 4 ]; then
        echo "Usage: $0 worker <worker_index> <proxmox_node> <vm_id>"
        exit 1
    fi
    WORKER_INDEX=$2
    PROXMOX_NODE=$3
    VM_ID=$4
    terraform import "module.k3s-cluster.module.k3s-worker[${WORKER_INDEX}].proxmox_vm_qemu.node" "${PROXMOX_NODE}/qemu/${VM_ID}"
else
    echo "Invalid resource type. Must be 'master' or 'worker'."
    exit 1
fi
