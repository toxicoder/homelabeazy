output "ip" {
  description = "The IP address of the resource."
  value       = var.resource_type == "qemu" ? element(proxmox_vm_qemu.vm.*.default_ipv4_address, 0) : element(proxmox_lxc.lxc.*.network[0].ip, 0)
}
