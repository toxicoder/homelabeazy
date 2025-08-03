variable "pm_api_url" {
  description = "The URL of the Proxmox API."
  type        = string
}

variable "target_node" {
  description = "The Proxmox node to create the VMs on."
  type        = string
}

variable "clone" {
  description = "The name of the template to clone."
  type        = string
}

variable "master_vmid" {
  description = "The ID of the master VM."
  type        = number
}

variable "worker_vmid_start" {
  description = "The starting ID of the worker VMs."
  type        = number
}

variable "service_vlan_tag" {
  description = "The VLAN tag for the service network."
  type        = number
  default     = 10
}

variable "service_bridge" {
  description = "The bridge for the service network."
  type        = string
  default     = "vmbr2"
}

variable "enable_stealth_vm" {
  description = "Enable the stealth VM."
  type        = bool
  default     = false
}

variable "windows_iso" {
  description = "The path to the Windows ISO."
  type        = string
  default     = ""
}

variable "bios" {
  description = "The BIOS to use for the stealth VM."
  type        = string
  default     = "ovmf"
}

variable "machine" {
  description = "The machine type for the stealth VM."
  type        = string
  default     = "q35"
}

variable "cpu" {
  description = "The CPU type for the stealth VM."
  type        = string
  default     = "host"
}

variable "cores" {
  description = "The number of cores for the stealth VM."
  type        = number
  default     = 4
}

variable "memory" {
  description = "The amount of memory for the stealth VM."
  type        = number
  default     = 8192
}

variable "scsihw" {
  description = "The SCSI hardware for the stealth VM."
  type        = string
  default     = "virtio-scsi-pci"
}

variable "bootdisk" {
  description = "The boot disk for the stealth VM."
  type        = string
  default     = "scsi0"
}

variable "network_model" {
  description = "The network model for the stealth VM."
  type        = string
  default     = "e1000"
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

variable "smbios_uuid" {
  description = "The SMBIOS UUID for the stealth VM."
  type        = string
  default     = ""
}
