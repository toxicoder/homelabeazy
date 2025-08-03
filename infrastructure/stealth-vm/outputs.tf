output "stealth_vm_ip" {
  description = "The IP address of the stealth VM"
  value       = proxmox_vm_qemu.stealth_vm[0].default_ipv4_address
}
