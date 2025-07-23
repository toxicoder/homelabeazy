output "master_ip" {
  description = "The IP address of the master node."
  value       = module.k3s_master.ip
}

output "worker_ips" {
  description = "The IP addresses of the worker nodes."
  value       = module.k3s_worker.*.ip
}
