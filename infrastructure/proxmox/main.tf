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

module "test_vm" {
  source = "./modules/test_vm"

  name        = var.test_vm_name
  target_node = var.target_node
  clone       = var.test_vm_clone
  vmid        = var.test_vm_vmid
  memory      = var.test_vm_memory
  sockets     = var.test_vm_sockets
  cores       = var.test_vm_cores
  os_type     = var.test_vm_os_type
  networks    = var.test_vm_networks
}

module "test_lxc" {
  source = "./modules/test_lxc"

  hostname    = var.test_lxc_hostname
  target_node = var.target_node
  vmid        = var.test_lxc_vmid
  memory      = var.test_lxc_memory
  cores       = var.test_lxc_cores
  service_bridge = var.service_bridge
  service_vlan_tag = var.service_vlan_tag
}
