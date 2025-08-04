terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.14, < 4.0.0"
    }
  }
}

resource "proxmox_lxc" "container" {
  count = var.instance_type == "lxc" ? 1 : 0

  target_node = var.target_node
  hostname    = var.hostname != "" ? var.hostname : var.name
  vmid        = var.vmid

  memory = var.memory
  cores  = var.cores

  network {
    name   = "eth0"
    bridge = var.network_bridge
    tag    = var.vlan_tag
  }
}

resource "proxmox_vm_qemu" "vm" {
  count = var.instance_type == "qemu" ? 1 : 0

  name        = var.name
  target_node = var.target_node
  clone       = var.clone
  vmid        = var.vmid

  memory  = var.memory
  sockets = var.sockets
  cores   = var.cores

  os_type = var.os_type
  agent   = var.agent

  network {
    model   = var.network_model
    bridge  = var.network_bridge
    tag     = var.vlan_tag
    macaddr = var.mac != "" ? var.mac : null
  }
}
