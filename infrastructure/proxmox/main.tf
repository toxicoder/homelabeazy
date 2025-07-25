terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.25.0"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_tls_insecure = false
}

module "k3s" {
  source = "./modules/k3s"

  target_node       = var.target_node
  clone             = var.clone
  master_vmid       = var.master_vmid
  worker_vmid_start = var.worker_vmid_start
}

resource "proxmox_vm_qemu" "test_vm" {
  name        = "test-vm"
  target_node = "pve"
  vmid        = 100
  memory      = 2048
  sockets     = 1
  cores       = 2
  os_type     = "cloud-init"
}

resource "proxmox_lxc" "test_lxc" {
  hostname    = "test-lxc"
  target_node = "pve"
  vmid        = 101
  memory      = 1024
  cores       = 1
}
