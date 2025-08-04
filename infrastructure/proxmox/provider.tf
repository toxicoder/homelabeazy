provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_api_token_id = var.pm_token_id
  pm_api_token_secret = var.pm_token_secret
  pm_tls_insecure = false
}
