variable "stealth_vm_enabled" {
  description = "If set to true, the stealth VM will be created."
  type        = bool
  default     = false
}

variable "stealth_vm_windows_iso" {
  description = "The path to the Windows ISO file. This is required for the stealth VM."
  type        = string
  default     = ""
}

variable "stealth_vm_gpu_pci_id" {
  description = "The PCI ID of the GPU to pass through to the stealth VM."
  type        = string
  default     = ""
}

variable "stealth_vm_hv_vendor_id" {
  description = "The Hyper-V vendor ID to use for the stealth VM. Can be either 'amd' or 'intel'."
  type        = string
  default     = "amd"
}

variable "stealth_vm_real_mac" {
  description = "The MAC address of the physical network card to use for the stealth VM."
  type        = string
  default     = ""
}

variable "stealth_vm_smbios_uuid" {
  description = "The SMBIOS UUID to use for the stealth VM."
  type        = string
  default     = ""
}

variable "proxmox_node" {
  description = "The Proxmox node to deploy the stealth VM on."
  type        = string
  default     = ""
}

variable "stealth_vm_bios" {
  description = "The BIOS to use for the stealth VM."
  type        = string
  default     = "ovmf"
}

variable "stealth_vm_machine" {
  description = "The machine type to use for the stealth VM."
  type        = string
  default     = "q35"
}

variable "stealth_vm_cpu" {
  description = "The CPU type to use for the stealth VM."
  type        = string
  default     = "host"
}

variable "stealth_vm_cores" {
  description = "The number of cores to use for the stealth VM."
  type        = number
  default     = 4
}

variable "stealth_vm_memory" {
  description = "The amount of memory to use for the stealth VM."
  type        = number
  default     = 8192
}

variable "stealth_vm_scsihw" {
  description = "The SCSI hardware to use for the stealth VM."
  type        = string
  default     = "lsi"
}

variable "stealth_vm_bootdisk" {
  description = "The boot disk to use for the stealth VM."
  type        = string
  default     = "scsi0"
}

variable "stealth_vm_network_model" {
  description = "The network model to use for the stealth VM."
  type        = string
  default     = "virtio"
}

variable "proxmox_service_bridge" {
  description = "The network bridge to use for the stealth VM."
  type        = string
  default     = "vmbr0"
}
