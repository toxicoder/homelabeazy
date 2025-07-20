terraform {
  backend "http" {
  }
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

locals {
  env = terraform.workspace
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_user    = var.proxmox_api_user
  pm_password = var.proxmox_api_password
  pm_tls_insecure = true
}
