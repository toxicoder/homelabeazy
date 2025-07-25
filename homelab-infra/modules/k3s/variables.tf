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

variable "master_memory" {
  description = "The amount of memory to allocate to the master VM."
  type        = number
  default     = 2048
}

variable "master_sockets" {
  description = "The number of CPU sockets to allocate to the master VM."
  type        = number
  default     = 1
}

variable "master_cores" {
  description = "The number of CPU cores to allocate to the master VM."
  type        = number
  default     = 2
}

variable "network_bridge" {
  description = "The network bridge to use for the VMs."
  type        = string
  default     = "vmbr0"
}

variable "agent" {
  description = "Enable/disable the QEMU agent."
  type        = number
  default     = 0
}

variable "mac" {
  description = "The MAC address of the VMs."
  type        = string
  default     = ""
}

variable "vlan" {
  description = "The VLAN tag for the VMs' network interface."
  type        = number
  default     = -1
}

variable "worker_count" {
  description = "The number of worker nodes to create."
  type        = number
  default     = 1
}

variable "worker_vmid_start" {
  description = "The starting ID of the worker VMs."
  type        = number
}

variable "worker_memory" {
  description = "The amount of memory to allocate to the worker VMs."
  type        = number
  default     = 2048
}

variable "worker_sockets" {
  description = "The number of CPU sockets to allocate to the worker VMs."
  type        = number
  default     = 1
}

variable "worker_cores" {
  description = "The number of CPU cores to allocate to the worker VMs."
  type        = number
  default     = 2
}
