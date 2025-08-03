terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.14, < 4.0.0"
    }
  }
}

resource "proxmox_vm_qemu" "test_vm" {
  name        = var.name
  target_node = var.target_node
  clone       = var.clone
  vmid        = var.vmid
  memory      = var.memory
  sockets     = var.sockets
  cores       = var.cores
  os_type     = var.os_type

  dynamic "network" {
    for_each = var.networks
    content {
      model  = network.value.model
      bridge = network.value.bridge
      tag    = lookup(network.value, "tag", null)
    }
  }
}
