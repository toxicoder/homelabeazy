variable "name" {
  description = "The name of the VM."
  type        = string
}

variable "target_node" {
  description = "The Proxmox node to create the VM on."
  type        = string
}

variable "clone" {
  description = "The template to clone."
  type        = string
}

variable "vmid" {
  description = "The VM ID."
  type        = number
}

variable "memory" {
  description = "The amount of memory in MB."
  type        = number
}

variable "sockets" {
  description = "The number of CPU sockets."
  type        = number
}

variable "cores" {
  description = "The number of CPU cores."
  type        = number
}

variable "agent" {
  description = "Enable/disable the QEMU agent."
  type        = number
  default     = 1
}

variable "network_bridge" {
  description = "The network bridge."
  type        = string
}

variable "mac" {
  description = "The MAC address of the network interface."
  type        = string
}

variable "vlan_tag" {
  description = "The VLAN tag."
  type        = number
}
