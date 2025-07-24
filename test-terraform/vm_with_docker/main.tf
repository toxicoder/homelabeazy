module "vm_with_docker" {
  source = "../modules/proxmox_vm"

  name        = "vm-with-docker"
  target_node = "proxmox"
  clone       = "ubuntu-22.04-cloud-init"
  vmid        = 100
  memory      = 4096
  sockets     = 1
  cores       = 2
  os_type     = "cloud-init"
}
