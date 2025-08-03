resource "proxmox_vm_qemu" "node" {
  name        = var.name
  target_node = var.target_node
  clone       = var.clone
  vmid        = var.vmid
  memory      = var.memory
  sockets     = var.sockets
  cores       = var.cores
  os_type     = "cloud-init"
  agent       = var.agent

  network {
    bridge  = var.network_bridge
    macaddr = var.mac
    tag     = var.vlan_tag
    model   = "virtio"
  }
}
