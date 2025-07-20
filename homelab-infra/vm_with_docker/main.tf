resource "proxmox_vm_qemu" "vm_with_docker" {
  name = "vm-with-docker"
  target_node = "proxmox"
  vmid = 100
  memory = 4096
  sockets = 1
  cores = 2
  os_type = "cloud-init"
}
