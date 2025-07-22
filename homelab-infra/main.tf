terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.25.0"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.pm_api_url
  pm_tls_insecure = false
}

module "stealth_vm" {
  source = "../stealth-vm/terraform"

  enable_stealth_vm = var.enable_stealth_vm
  windows_iso       = var.windows_iso
  gpu_pci_id        = var.gpu_pci_id
  hv_vendor_id      = var.hv_vendor_id
  real_mac          = var.real_mac
  smbios_uuid       = var.smbios_uuid
  proxmox_host      = var.proxmox_host
}
