variable "pm_api_url" {
  type        = string
  description = "Proxmox API URL"
}

variable "pm_api_user" {
  type        = string
  description = "Proxmox API user"
}

variable "pm_api_pass" {
  type        = string
  description = "Proxmox API password"
  sensitive   = true
}

variable "proxmox_host" {
  type        = string
  description = "Proxmox target node"
}

variable "template_name" {
  type        = string
  description = "VM template name"
}

variable "template_vmid" {
  type        = number
  description = "VM template vmid"
}

variable "os_image_url" {
  type        = string
  description = "OS image URL"
}

variable "k3s_master_count" {
  type        = number
  description = "Number of k3s master nodes"
}

variable "k3s_master_prefix" {
  type        = string
  description = "Prefix for k3s master nodes"
}

variable "k3s_master_cpu" {
  type        = number
  description = "Number of CPU cores for k3s master nodes"
}

variable "k3s_master_memory" {
  type        = number
  description = "Memory for k3s master nodes in MB"
}

variable "k3s_master_disk_size" {
  type        = string
  description = "Disk size for k3s master nodes"
}

variable "k3s_worker_count" {
  type        = number
  description = "Number of k3s worker nodes"
}

variable "k3s_worker_prefix" {
  type        = string
  description = "Prefix for k3s worker nodes"
}

variable "k3s_worker_cpu" {
  type        = number
  description = "Number of CPU cores for k3s worker nodes"
}

variable "k3s_worker_memory" {
  type        = number
  description = "Memory for k3s worker nodes in MB"
}

variable "k3s_worker_disk_size" {
  type        = string
  description = "Disk size for k3s worker nodes"
}

variable "network_bridge" {
  type        = string
  description = "Network bridge"
}

variable "network_vlan_tag" {
  type        = number
  description = "Network VLAN tag"
}

variable "network_gateway" {
  type        = string
  description = "Network gateway"
}

variable "network_cidr" {
  type        = string
  description = "Network CIDR"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key"
  sensitive   = true
}
