resource "proxmox_vm_qemu" "pfsense_vm" {
  name        = "pfsense"
  target_node = "proxmox"
  clone       = "pfsense-template"
  vmid        = 101
  memory      = 2048
  sockets     = 1
  cores       = 2
  os_type     = "other"

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  network {
    model  = "virtio"
    bridge = "vmbr1"
  }
}
