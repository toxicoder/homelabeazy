variable "name" {
  description = "The name of the resource."
  type        = string
  default     = null
}

variable "target_node" {
  description = "The Proxmox node to create the resource on."
  type        = string
}

variable "clone" {
  description = "The name of the template to clone."
  type        = string
  default     = null
}

variable "vmid" {
  description = "The ID of the resource."
  type        = number
}

variable "memory" {
  description = "The amount of memory to allocate to the resource."
  type        = number
}

variable "sockets" {
  description = "The number of CPU sockets to allocate to the VM."
  type        = number
  default     = 1
}

variable "cores" {
  description = "The number of CPU cores to allocate to the resource."
  type        = number
}

variable "os_type" {
  description = "The OS type of the VM."
  type        = string
  default     = "cloud-init"
}

variable "networks" {
  description = "A list of network interfaces for the VM."
  type = list(object({
    bridge  = string
    model   = optional(string, "virtio")
    macaddr = optional(string)
    tag     = optional(number, -1)
  }))
  default = [{
    bridge = "vmbr0"
  }]
}

variable "agent" {
  description = "Enable/disable the QEMU agent."
  type        = number
  default     = 0
}

variable "resource_type" {
  description = "The type of resource to create, either 'qemu' or 'lxc'."
  type        = string
  default     = "qemu"
}

variable "hostname" {
  description = "The hostname of the LXC container."
  type        = string
  default     = null
}

variable "ostemplate" {
  description = "The LXC template to use."
  type        = string
  default     = null
}

variable "password" {
  description = "The password for the LXC container."
  type        = string
  default     = null
}

variable "storage" {
  description = "The storage for the LXC container's rootfs."
  type        = string
  default     = "local-lvm"
}

variable "unprivileged" {
  description = "Whether the LXC container is unprivileged."
  type        = bool
  default     = true
}

variable "bios" {
  description = "The BIOS to use for the VM."
  type        = string
  default     = "seabios"
}

variable "machine" {
  description = "The machine type for the VM."
  type        = string
  default     = null
}

variable "cpu" {
  description = "The CPU type for the VM."
  type        = string
  default     = "kvm64"
}

variable "scsihw" {
  description = "The SCSI hardware for the VM."
  type        = string
  default     = "virtio-scsi-pci"
}

variable "bootdisk" {
  description = "The boot disk for the VM."
  type        = string
  default     = null
}
