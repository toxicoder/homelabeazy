resource "proxmox_vm_qemu" "vm" {
  name        = var.name
  target_node = var.target_node
  clone       = var.clone
  vmid        = var.vmid
  memory      = var.memory
  sockets     = var.sockets
  cores       = var.cores
  os_type     = var.os_type
  agent       = var.agent

  network {
    model   = "virtio"
    bridge  = var.network_bridge
    macaddr = var.mac
    tag     = var.vlan
  }
}
