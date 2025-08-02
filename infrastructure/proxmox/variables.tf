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

variable "test_vm_name" {
  description = "The name of the test VM."
  type        = string
  default     = "pfsense"
}

variable "test_vm_clone" {
  description = "The name of the template to clone for the test VM."
  type        = string
  default     = "pfsense-template"
}

variable "test_vm_vmid" {
  description = "The ID of the test VM."
  type        = number
  default     = 101
}

variable "test_vm_memory" {
  description = "The amount of memory for the test VM."
  type        = number
  default     = 2048
}

variable "test_vm_sockets" {
  description = "The number of sockets for the test VM."
  type        = number
  default     = 1
}

variable "test_vm_cores" {
  description = "The number of cores for the test VM."
  type        = number
  default     = 2
}

variable "test_vm_os_type" {
  description = "The OS type of the test VM."
  type        = string
  default     = "other"
}

variable "test_vm_networks" {
  description = "The network configuration for the test VM."
  type        = any
  default = [
    {
      model  = "virtio"
      bridge = "vmbr0"
    },
    {
      model  = "virtio"
      bridge = "vmbr1"
    },
    {
      model  = "virtio"
      bridge = "vmbr2"
      tag    = 10
    }
  ]
}

variable "test_lxc_hostname" {
  description = "The hostname of the test LXC."
  type        = string
  default     = "lxc-with-docker"
}

variable "test_lxc_vmid" {
  description = "The ID of the test LXC."
  type        = number
  default     = 102
}

variable "test_lxc_memory" {
  description = "The amount of memory for the test LXC."
  type        = number
  default     = 2048
}

variable "test_lxc_cores" {
  description = "The number of cores for the test LXC."
  type        = number
  default     = 1
}

variable "lxc_template" {
  description = "The LXC template to use."
  type        = string
  default     = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.gz"
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
