variable "enable_stealth_vm" {
  description = "Enable the stealth VM."
  type        = bool
  default     = false
}

variable "target_node" {
  description = "The Proxmox node to create the VMs on."
  type        = string
}

variable "windows_iso" {
  description = "The path to the Windows ISO."
  type        = string
  default     = ""
}

variable "service_bridge" {
  description = "The bridge for the service network."
  type        = string
  default     = "vmbr2"
}

variable "real_mac" {
  description = "The real MAC address for the stealth VM."
  type        = string
  default     = ""
}

variable "gpu_pci_id" {
  description = "The PCI ID of the GPU to pass through."
  type        = string
  default     = ""
}

variable "hv_vendor_id" {
  description = "The hypervisor vendor ID for the stealth VM."
  type        = string
  default     = "GenuineIntel"
}
