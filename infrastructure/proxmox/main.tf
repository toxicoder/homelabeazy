terraform {
  required_version = ">= 1.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.14, < 4.0.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.25.0"
    }
  }
}

module "k3s" {
  source = "./modules/k3s"

  target_node       = var.target_node
  clone             = var.clone
  master_vmid       = var.master_vmid
  worker_vmid_start = var.worker_vmid_start
}

module "test_vm" {
  source = "./modules/proxmox_vm"

  resource_type  = "qemu"
  name           = "test-vm"
  target_node    = "pve"
  vmid           = 100
  memory         = 2048
  sockets        = 1
  cores          = 2
  os_type        = "cloud-init"
  network_bridge = var.service_bridge
  vlan           = var.service_vlan_tag
}

module "test_lxc" {
  source = "./modules/proxmox_vm"

  resource_type = "lxc"
  hostname      = "test-lxc"
  target_node   = "pve"
  vmid          = 101
  memory        = 1024
  cores         = 1
  ostemplate    = var.lxc_template
  vlan          = var.service_vlan_tag
}

module "stealth-vm" {
  source = "../stealth-vm"

  enable_stealth_vm = var.enable_stealth_vm
  proxmox_host      = var.target_node
  windows_iso       = var.windows_iso
  bios              = var.bios
  machine           = var.machine
  cpu               = var.cpu
  cores             = var.cores
  memory            = var.memory
  scsihw            = var.scsihw
  bootdisk          = var.bootdisk
  network_model     = var.network_model
  network_bridge    = var.service_bridge
  real_mac          = var.real_mac
  gpu_pci_id        = var.gpu_pci_id
  hv_vendor_id      = var.hv_vendor_id
  smbios_uuid       = var.smbios_uuid
}
