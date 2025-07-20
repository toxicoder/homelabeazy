terraform {
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
  pm_api_url = var.pm_api_url
  pm_user    = var.pm_api_user
  pm_password = var.pm_api_password
  pm_tls_insecure = false
}
