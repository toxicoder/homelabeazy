terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.25.0"
    }
  }
}

data "vault_generic_secret" "proxmox_credentials" {
  path = "secret/proxmox"
}

provider "proxmox" {
  pm_api_url = var.pm_api_url
  pm_api_user = var.pm_api_user
  pm_api_pass = data.vault_generic_secret.proxmox_credentials.data["password"]
  pm_tls_insecure = false
}
