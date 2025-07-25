terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
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
}
