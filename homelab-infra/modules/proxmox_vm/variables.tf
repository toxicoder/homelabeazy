variable "name" {
  description = "The name of the VM."
  type        = string
}

variable "target_node" {
  description = "The Proxmox node to create the VM on."
  type        = string
}

variable "clone" {
  description = "The name of the template to clone."
  type        = string
}

variable "vmid" {
  description = "The ID of the VM."
  type        = number
}

variable "memory" {
  description = "The amount of memory to allocate to the VM."
  type        = number
}

variable "sockets" {
  description = "The number of CPU sockets to allocate to the VM."
  type        = number
}

variable "cores" {
  description = "The number of CPU cores to allocate to the VM."
  type        = number
}

variable "os_type" {
  description = "The OS type of the VM."
  type        = string
}

variable "network_bridge" {
  description = "The network bridge to use for the VM."
  type        = string
  default     = "vmbr0"
}

variable "agent" {
  description = "Enable/disable the QEMU agent."
  type        = number
  default     = 0
}

variable "mac" {
  description = "The MAC address of the VM."
  type        = string
  default     = ""
}

variable "vlan" {
  description = "The VLAN tag for the VM's network interface."
  type        = number
  default     = -1
}
