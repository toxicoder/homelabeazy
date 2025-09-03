output "k3s_master_ip" {
  description = "The IP address of the k3s master node."
  value       = module.k3s-master.ip_address
}

output "k3s_worker_ips" {
  description = "A list of IP addresses for the k3s worker nodes."
  value       = module.k3s-workers[*].ip_address
}

output "k3s_master_name" {
  description = "The hostname of the k3s master node."
  value       = module.k3s-master.name
}

output "k3s_worker_names" {
  description = "A list of hostnames for the k3s worker nodes."
  value       = module.k3s-workers[*].name
}
