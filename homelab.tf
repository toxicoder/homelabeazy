resource "proxmox_vm_qemu" "vm1" {
  name = "vm1"
  target_node = "pve"
  vmid = 100
  memory = 4096
  sockets = 1
  cores = 2
  os_type = "cloud-init"
}

resource "proxmox_lxc" "lxc1" {
  hostname = "lxc1"
  target_node = "pve"
  vmid = 101
  memory = 1024
  cores = 1
}
