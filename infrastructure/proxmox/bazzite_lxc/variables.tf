variable "hostname" {
  description = "The hostname of the Bazzite LXC."
  type        = string
  default     = "bazzite"
}

variable "target_node" {
  description = "The Proxmox node to create the LXC on."
  type        = string
}

variable "vmid" {
  description = "The VM ID of the LXC."
  type        = number
}

variable "memory" {
  description = "The amount of memory for the LXC in MB."
  type        = number
  default     = 4096
}

variable "cores" {
  description = "The number of CPU cores for the LXC."
  type        = number
  default     = 2
}

variable "ostemplate" {
  description = "The Proxmox template to use for the LXC. This must be a Bazzite template."
  type        = string
}
