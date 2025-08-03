variable "name" {
  description = "The name of the pfSense VM."
  type        = string
  default     = "pfsense"
}

variable "target_node" {
  description = "The Proxmox node to create the VM on."
  type        = string
}

variable "clone" {
  description = "The template to clone for the pfSense VM."
  type        = string
  default     = "pfsense-template"
}

variable "vmid" {
  description = "The VM ID for the pfSense VM."
  type        = number
}

variable "memory" {
  description = "The amount of memory for the pfSense VM."
  type        = number
  default     = 2048
}

variable "sockets" {
  description = "The number of sockets for the pfSense VM."
  type        = number
  default     = 1
}

variable "cores" {
  description = "The number of cores for the pfSense VM."
  type        = number
  default     = 2
}

variable "os_type" {
  description = "The operating system type."
  type        = string
  default     = "other"
}

variable "wan_bridge" {
  description = "The name of the WAN bridge for pfSense."
  type        = string
  default     = "vmbr1"
}

variable "lan_bridge" {
  description = "The name of the LAN bridge for pfSense."
  type        = string
  default     = "vmbr0"
}

variable "service_bridge" {
  description = "The bridge for the service network."
  type        = string
}

variable "service_vlan_tag" {
  description = "The VLAN tag for the service network."
  type        = number
}
