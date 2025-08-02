resource "proxmox_lxc" "bazzite_lxc" {
  hostname      = var.hostname
  target_node   = var.target_node
  vmid          = var.vmid
  memory        = var.memory
  cores         = var.cores
  ostemplate    = var.ostemplate
  unprivileged  = true

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }
}
