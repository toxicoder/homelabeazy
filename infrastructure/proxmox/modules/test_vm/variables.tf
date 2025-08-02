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
  description = "The amount of memory for the VM."
  type        = number
}

variable "sockets" {
  description = "The number of sockets for the VM."
  type        = number
}

variable "cores" {
  description = "The number of cores for the VM."
  type        = number
}

variable "os_type" {
  description = "The OS type of the VM."
  type        = string
}

variable "networks" {
  description = "A list of network interfaces for the VM."
  type = list(object({
    model  = string
    bridge = string
    tag    = optional(number)
  }))
  default = []
}
