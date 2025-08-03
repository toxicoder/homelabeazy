terraform {
  required_version = ">= 1.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.14, < 4.0.0"
    }
  }
}

resource "proxmox_vm_qemu" "pfsense_vm" {
  name        = var.name
  target_node = var.target_node
  clone       = var.clone
  vmid        = var.vmid
  memory      = var.memory
  sockets     = var.sockets
  cores       = var.cores
  os_type     = var.os_type

  network {
    model  = "virtio"
    bridge = var.wan_bridge
  }

  network {
    model  = "virtio"
    bridge = var.lan_bridge
  }

  network {
    model  = "virtio"
    bridge = var.service_bridge
    tag    = var.service_vlan_tag
  }
}
