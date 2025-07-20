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
  # pm_password = var.pm_api_password # This is no longer used.
  # Instead, we use a Proxmox API token.
  # To generate a token, go to Datacenter -> Permissions -> API Tokens
  # and create a new token with the appropriate permissions.
  # Then, set the pm_token_id and pm_token_secret variables in your secrets.yml file.
  pm_token_id = var.pm_token_id
  pm_token_secret = var.pm_token_secret
  pm_tls_insecure = false
}
