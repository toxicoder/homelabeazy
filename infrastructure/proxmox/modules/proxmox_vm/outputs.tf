output "ip" {
  description = "The IP address of the VM."
  value       = proxmox_vm_qemu.vm.default_ipv4_address
}
