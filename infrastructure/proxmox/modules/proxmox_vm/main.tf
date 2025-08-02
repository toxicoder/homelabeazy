terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.14, < 4.0.0"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  count = var.resource_type == "qemu" ? 1 : 0

  name        = var.name
  target_node = var.target_node
  clone       = var.clone
  vmid        = var.vmid
  memory      = var.memory
  sockets     = var.sockets
  cores       = var.cores
  os_type     = var.os_type
  agent       = var.agent
  bios        = var.bios
  machine     = var.machine
  cpu         = var.cpu
  scsihw      = var.scsihw
  bootdisk    = var.bootdisk

  dynamic "network" {
    for_each = var.networks
    content {
      model   = lookup(network.value, "model", "virtio")
      bridge  = network.value.bridge
      macaddr = lookup(network.value, "macaddr", null)
      tag     = lookup(network.value, "tag", -1)
    }
  }
}

resource "proxmox_lxc" "lxc" {
  count = var.resource_type == "lxc" ? 1 : 0

  hostname     = var.hostname
  target_node  = var.target_node
  vmid         = var.vmid
  memory       = var.memory
  cores        = var.cores
  ostemplate   = var.ostemplate
  password     = var.password
  unprivileged = var.unprivileged

  rootfs {
    storage = var.storage
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = var.network_bridge
    ip     = "dhcp"
    tag    = var.vlan
  }
}
