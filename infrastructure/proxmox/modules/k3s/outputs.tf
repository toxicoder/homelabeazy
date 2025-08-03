output "master_ip" {
  description = "The IP address of the master node."
  value       = proxmox_vm_qemu.k3s_master.default_ipv4_address
}

output "worker_ips" {
  description = "The IP addresses of the worker nodes."
  value       = proxmox_vm_qemu.k3s_worker[*].default_ipv4_address
}
