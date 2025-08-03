variable "hostname" {
  description = "The hostname of the LXC container."
  type        = string
}

variable "target_node" {
  description = "The Proxmox node to create the LXC container on."
  type        = string
}

variable "vmid" {
  description = "The ID of the LXC container."
  type        = number
}

variable "memory" {
  description = "The amount of memory for the LXC container."
  type        = number
}

variable "cores" {
  description = "The number of cores for the LXC container."
  type        = number
}

variable "service_bridge" {
  description = "The name of the network bridge for the service network."
  type        = string
}

variable "service_vlan_tag" {
  description = "The VLAN tag for the service network."
  type        = number
}
