terraform {
  required_version = ">= 1.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.14, < 4.0.0"
    }
  }
}

variable "service_bridge" {
  description = "The name of the network bridge for the service network."
  type        = string
}

variable "service_vlan_tag" {
  description = "The VLAN tag for the service network."
  type        = number
}

resource "proxmox_lxc" "lxc_with_docker" {
  hostname = "lxc-with-docker"
  target_node = "proxmox"
  vmid = 101
  memory = 2048
  cores = 1

  network {
    name    = "eth0"
    bridge  = var.service_bridge
    ip      = "dhcp"
    vlan_id = var.service_vlan_tag
  }
}
