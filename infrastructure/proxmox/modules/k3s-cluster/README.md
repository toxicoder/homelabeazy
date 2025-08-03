# Terraform Module: k3s-cluster

This module creates a K3s cluster in Proxmox, with one master and a configurable number of workers.

## Usage

```terraform
module "k3s-cluster" {
  source = "./modules/k3s-cluster"

  target_node        = "pve"
  clone              = "ubuntu-2204-cloud-init"
  master_vm_id       = 100
  worker_vm_id_start = 101
  # ... other variables
}
```

## Variables

See `variables.tf` for a full list of available variables.

## Outputs

See `outputs.tf` for a list of outputs.
