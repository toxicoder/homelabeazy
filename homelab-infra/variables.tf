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
