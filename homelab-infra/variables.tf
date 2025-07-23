variable "pm_api_url" {
  description = "The URL of the Proxmox API."
  type        = string
  default     = "https://localhost:8006/api2/json"
}

variable "enable_stealth_vm" {
  description = "If set to true, the stealth VM will be created."
  type        = bool
  default     = false
}

variable "windows_iso" {
  description = "The path to the Windows ISO file. This is required for the stealth VM."
  type        = string
  default     = ""
}

variable "gpu_pci_id" {
  description = "The PCI ID of the GPU to pass through to the stealth VM."
  type        = string
  default     = ""
}

variable "hv_vendor_id" {
  description = "The Hyper-V vendor ID to use for the stealth VM. Can be either 'amd' or 'intel'."
  type        = string
  default     = "amd"
}

variable "real_mac" {
  description = "The MAC address of the physical network card to use for the stealth VM."
  type        = string
  default     = ""
}

variable "smbios_uuid" {
  description = "The SMBIOS UUID to use for the stealth VM."
  type        = string
  default     = ""
}

variable "proxmox_host" {
  description = "The Proxmox host to deploy the stealth VM on."
  type        = string
  default     = ""
}
