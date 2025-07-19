variable "proxmox_api_url" {
  type        = string
  description = "The URL for the Proxmox API."
}

variable "proxmox_api_user" {
  type        = string
  description = "The user for the Proxmox API."
}

variable "proxmox_api_password" {
  type        = string
  description = "The password for the Proxmox API."
  sensitive   = true
}
