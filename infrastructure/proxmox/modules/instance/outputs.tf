output "instance_id" {
  description = "The ID of the created instance."
  value       = var.instance_type == "lxc" ? proxmox_lxc.container[0].id : proxmox_vm_qemu.vm[0].id
}

output "ip_address" {
  description = "The default IPv4 address of the VM."
  value       = one(proxmox_vm_qemu.vm[*].default_ipv4_address)
}

output "name" {
  description = "The name of the instance."
  value       = one(proxmox_vm_qemu.vm[*].name)
}
