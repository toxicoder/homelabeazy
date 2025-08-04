# ----------------------------------------------------------------------------------------------------------------------
# General VM Settings
# ----------------------------------------------------------------------------------------------------------------------
variable "stealth_vm_enabled" {
  description = "If set to true, the stealth VM will be created. This is the master switch for the entire module."
  type        = bool
  default     = false
}

variable "stealth_vm_name" {
  description = "The name of the stealth VM. This will be used as the hostname."
  type        = string
  default     = "stealth-vm"
}

variable "proxmox_node" {
  description = "The Proxmox node where the stealth VM will be deployed. This must be an existing node."
  type        = string
}

variable "stealth_vm_onboot" {
  description = "Controls whether the stealth VM will automatically start when the Proxmox node boots."
  type        = bool
  default     = true
}

# ----------------------------------------------------------------------------------------------------------------------
# Hardware Configuration
# ----------------------------------------------------------------------------------------------------------------------

variable "stealth_vm_bios" {
  description = "The BIOS to use for the stealth VM. Use 'ovmf' for UEFI or 'seabios' for legacy BIOS."
  type        = string
  default     = "ovmf"
}

variable "stealth_vm_machine" {
  description = "The machine type for the VM. 'q35' is a modern type with better support for PCIe."
  type        = string
  default     = "q35"
}

variable "stealth_vm_cpu" {
  description = "The CPU type for the stealth VM. 'host' passes through the host CPU for best performance."
  type        = string
  default     = "host"
}

variable "stealth_vm_cores" {
  description = "The number of CPU cores to allocate to the stealth VM."
  type        = number
  default     = 4
}

variable "stealth_vm_sockets" {
  description = "The number of CPU sockets to allocate to the stealth VM."
  type        = number
  default     = 1
}

variable "stealth_vm_memory" {
  description = "The amount of RAM to allocate to the stealth VM, in megabytes."
  type        = number
  default     = 8192
}

variable "stealth_vm_scsihw" {
  description = "The SCSI controller hardware to use for the stealth VM. 'lsi' is a common choice."
  type        = string
  default     = "lsi"
}

variable "stealth_vm_bootdisk" {
  description = "The primary boot disk for the stealth VM."
  type        = string
  default     = "scsi0"
}

# ----------------------------------------------------------------------------------------------------------------------
# Passthrough and Obfuscation
# ----------------------------------------------------------------------------------------------------------------------

variable "stealth_vm_gpu_pci_id" {
  description = "The PCI ID of the GPU to pass through to the stealth VM (e.g., '0000:01:00.0')."
  type        = string
  default     = ""
}

variable "stealth_vm_pcie_enabled" {
  description = "Enable PCIe for GPU passthrough. Should be enabled if passing through a modern GPU."
  type        = bool
  default     = true
}

variable "stealth_vm_hv_vendor_id" {
  description = "The Hyper-V vendor ID to present to the guest OS. Helps to hide the fact that it's a VM."
  type        = string
  default     = "amd"
}

variable "stealth_vm_smbios_uuid" {
  description = "A custom SMBIOS UUID to present to the guest OS. Helps to avoid VM detection."
  type        = string
  default     = ""
}

# ----------------------------------------------------------------------------------------------------------------------
# Network Configuration
# ----------------------------------------------------------------------------------------------------------------------

variable "proxmox_service_bridge" {
  description = "The Proxmox network bridge to connect the stealth VM to."
  type        = string
  default     = "vmbr0"
}

variable "stealth_vm_network_model" {
  description = "The network card model to present to the guest OS. 'virtio' offers the best performance."
  type        = string
  default     = "virtio"
}

variable "stealth_vm_real_mac" {
  description = "The MAC address of a real network card to use for the stealth VM. Helps to avoid VM detection."
  type        = string
  default     = ""
}

# ----------------------------------------------------------------------------------------------------------------------
# Guest OS and Agent
# ----------------------------------------------------------------------------------------------------------------------

variable "stealth_vm_windows_iso" {
  description = "The path on your Proxmox host to the Windows ISO file. Required for installation."
  type        = string
  default     = ""
}

variable "stealth_vm_agent_enabled" {
  description = "Enable the QEMU Guest Agent. This allows Proxmox to get more information from the VM."
  type        = bool
  default     = true
}
