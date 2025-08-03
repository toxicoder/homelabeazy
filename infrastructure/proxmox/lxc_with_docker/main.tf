resource "proxmox_lxc" "lxc_with_docker" {
  hostname    = "lxc-with-docker"
  target_node = "proxmox"
  vmid        = 101
  memory      = 2048
  cores       = 1
}
