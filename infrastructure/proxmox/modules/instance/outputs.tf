output "instance_id" {
  description = "The ID of the created instance."
  value       = var.instance_type == "lxc" ? proxmox_lxc.container[0].id : proxmox_vm_qemu.vm[0].id
}

output "instance_ip" {
  description = "The IP address of the created instance."
  value       = var.instance_type == "lxc" ? proxmox_lxc.container[0].ipv4_address : proxmox_vm_qemu.vm[0].default_ipv4_address
}
