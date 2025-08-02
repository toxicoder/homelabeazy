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

variable "smbios_manufacturer" {
  description = "The SMBIOS manufacturer to use for the stealth VM."
  type        = string
  default     = "ASUS"
}

variable "smbios_product" {
  description = "The SMBIOS product to use for the stealth VM."
  type        = string
  default     = "ROG Strix"
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

variable "bios" {
  description = "The BIOS to use for the stealth VM."
  type        = string
  default     = "ovmf"
}

variable "machine" {
  description = "The machine type to use for the stealth VM."
  type        = string
  default     = "q35"
}

variable "cpu" {
  description = "The CPU type to use for the stealth VM."
  type        = string
  default     = "host"
}

variable "cores" {
  description = "The number of cores to use for the stealth VM."
  type        = number
  default     = 4
}

variable "memory" {
  description = "The amount of memory to use for the stealth VM."
  type        = number
  default     = 8192
}

variable "scsihw" {
  description = "The SCSI hardware to use for the stealth VM."
  type        = string
  default     = "lsi"
}

variable "bootdisk" {
  description = "The boot disk to use for the stealth VM."
  type        = string
  default     = "scsi0"
}

variable "network_model" {
  description = "The network model to use for the stealth VM."
  type        = string
  default     = "virtio"
}

variable "network_bridge" {
  description = "The network bridge to use for the stealth VM."
  type        = string
  default     = "vmbr0"
}
