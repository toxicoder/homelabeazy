resource "proxmox_lxc" "test_lxc" {
  hostname    = var.hostname
  target_node = var.target_node
  vmid        = var.vmid
  memory      = var.memory
  cores       = var.cores
}
