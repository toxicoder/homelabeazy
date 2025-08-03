terraform {
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

  target_node       = var.proxmox_node
  clone             = var.proxmox_template
  master_vmid       = var.k3s_master_vm_id
  worker_vmid_start = var.k3s_worker_vm_id_start
  network_bridge    = var.proxmox_service_bridge
  vlan_tag          = var.proxmox_service_vlan_tag
}

module "test_vm" {
  source = "./modules/instance"

  instance_type = "qemu"
  name          = "test-vm"
  target_node   = "pve"
  vmid          = 100
  memory        = 2048
  sockets       = 1
  cores         = 2
  os_type       = "cloud-init"

  network_bridge = var.proxmox_service_bridge
  vlan_tag       = var.proxmox_service_vlan_tag
}

module "test_lxc" {
  source = "./modules/instance"

  instance_type = "lxc"
  hostname      = "test-lxc"
  target_node   = "pve"
  vmid          = 101
  memory        = 1024
  cores         = 1

  network_bridge = var.proxmox_service_bridge
}

module "stealth-vm" {
  source = "../stealth-vm"

  stealth_vm_enabled         = var.stealth_vm_enabled
  proxmox_node               = var.proxmox_node
  stealth_vm_windows_iso     = var.stealth_vm_windows_iso
  stealth_vm_bios            = var.stealth_vm_bios
  stealth_vm_machine         = var.stealth_vm_machine
  stealth_vm_cpu             = var.stealth_vm_cpu
  stealth_vm_cores           = var.stealth_vm_cores
  stealth_vm_memory          = var.stealth_vm_memory
  stealth_vm_scsihw          = var.stealth_vm_scsihw
  stealth_vm_bootdisk        = var.stealth_vm_bootdisk
  stealth_vm_network_model   = var.stealth_vm_network_model
  proxmox_service_bridge     = var.proxmox_service_bridge
  stealth_vm_real_mac        = var.stealth_vm_real_mac
  stealth_vm_gpu_pci_id      = var.stealth_vm_gpu_pci_id
  stealth_vm_hv_vendor_id    = var.stealth_vm_hv_vendor_id
  stealth_vm_smbios_uuid     = var.stealth_vm_smbios_uuid
}
