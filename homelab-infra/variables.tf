variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "pm_api_user" {
  description = "Proxmox API user"
  type        = string
}

variable "enable_stealth_vm" {
  description = "Enable the stealth VM"
  type        = bool
  default     = false
}

variable "windows_iso" {
  description = "Path to the Windows ISO file"
  type        = string
  default     = ""
}

variable "gpu_pci_id" {
  description = "PCI ID of the GPU to pass through"
  type        = string
  default     = ""
}

variable "hv_vendor_id" {
  description = "Hyper-V vendor ID (amd or intel)"
  type        = string
  default     = "amd"
}

variable "real_mac" {
  description = "MAC address of the physical network card"
  type        = string
  default     = ""
}

variable "smbios_uuid" {
  description = "SMBIOS UUID"
  type        = string
  default     = ""
}

variable "proxmox_host" {
  description = "Proxmox host to deploy the VM on"
  type        = string
  default     = ""
}
