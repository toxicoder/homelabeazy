terraform {
  required_version = ">= 1.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.14, < 4.0.0"
    }
  }
}

resource "proxmox_lxc" "lxc_with_docker" {
  hostname = "lxc-with-docker"
  target_node = "proxmox"
  vmid = 101
  memory = 2048
  cores = 1
}
