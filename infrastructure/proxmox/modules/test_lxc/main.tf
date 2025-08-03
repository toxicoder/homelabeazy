terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.14, < 4.0.0"
    }
  }
}

resource "proxmox_lxc" "test_lxc" {
  hostname    = var.hostname
  target_node = var.target_node
  vmid        = var.vmid
  memory      = var.memory
  cores       = var.cores

  network {
    name    = "eth0"
    bridge  = var.service_bridge
    ip      = "dhcp"
    vlan_id = var.service_vlan_tag
  }
}
