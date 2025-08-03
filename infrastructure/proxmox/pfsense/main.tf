terraform {
  required_version = ">= 1.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.14, < 4.0.0"
    }
  }
}

variable "pfsense_wan_bridge" {
  description = "The name of the WAN bridge for pfSense."
  type        = string
  default     = "vmbr1"
}

resource "proxmox_vm_qemu" "pfsense_vm" {
  name        = "pfsense"
  target_node = "proxmox"
  clone       = "pfsense-template"
  vmid        = 101
  memory      = 2048
  sockets     = 1
  cores       = 2
  os_type     = "other"

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  network {
    model  = "virtio"
    bridge = var.pfsense_wan_bridge
  }

  network {
    model  = "virtio"
    bridge = var.service_bridge
    tag    = var.service_vlan_tag
  }
}
