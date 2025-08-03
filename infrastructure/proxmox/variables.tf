variable "proxmox_api_url" {
  description = "The URL for the Proxmox API."
  type        = string
}

variable "pm_token_id" {
  description = "The Proxmox API token ID."
  type        = string
  sensitive   = true
}

variable "pm_token_secret" {
  description = "The Proxmox API token secret."
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "The Proxmox node to create the VMs on."
  type        = string
}

variable "proxmox_template" {
  description = "The name of the template to clone."
  type        = string
}

variable "proxmox_service_vlan_tag" {
  description = "The VLAN tag for the service network."
  type        = number
  default     = 10
}

variable "proxmox_service_bridge" {
  description = "The bridge for the service network."
  type        = string
  default     = "vmbr2"
}

variable "k3s_master_vm_id" {
  description = "The ID of the master VM."
  type        = number
}

variable "k3s_worker_vm_id_start" {
  description = "The starting ID of the worker VMs."
  type        = number
}

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
