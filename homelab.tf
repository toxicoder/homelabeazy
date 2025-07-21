resource "proxmox_vm_qemu" "test_vm" {
  name = "test-vm"
  target_node = "pve"
  vmid = 100
  memory = 2048
  sockets = 1
  cores = 2
  os_type = "cloud-init"
}

resource "proxmox_lxc" "test_lxc" {
  hostname = "test-lxc"
  target_node = "pve"
  vmid = 101
  memory = 1024
  cores = 1
}
