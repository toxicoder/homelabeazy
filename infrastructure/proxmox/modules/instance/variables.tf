variable "instance_type" {
  description = "Type of instance to create, 'lxc' or 'qemu'."
  type        = string
  default     = "lxc"
}

variable "name" {
  description = "The name of the instance."
  type        = string
}

variable "target_node" {
  description = "The Proxmox node to create the instance on."
  type        = string
}

variable "vmid" {
  description = "The VMID of the instance."
  type        = number
  default     = 0
}

variable "memory" {
  description = "The memory for the instance in MB."
  type        = number
  default     = 512
}

variable "cores" {
  description = "The number of CPU cores for the instance."
  type        = number
  default     = 1
}

variable "sockets" {
  description = "The number of CPU sockets for the instance."
  type        = number
  default     = 1
}

variable "network_bridge" {
  description = "The network bridge for the instance."
  type        = string
}

variable "network_model" {
  description = "The network model for the instance."
  type        = string
  default     = "virtio"
}

variable "vlan_tag" {
  description = "The VLAN tag for the instance."
  type        = number
  default     = -1 # -1 means no VLAN tag
}

variable "clone" {
  description = "The template to clone for QEMU VMs."
  type        = string
  default     = ""
}

variable "os_type" {
  description = "The OS type for QEMU VMs."
  type        = string
  default     = "cloud-init"
}

variable "agent" {
  description = "Enable/disable the QEMU guest agent."
  type        = number
  default     = 1
}

variable "mac" {
  description = "The MAC address of the network interface."
  type        = string
  default     = ""
}

variable "hostname" {
  description = "The hostname for the instance."
  type        = string
  default     = ""
}
