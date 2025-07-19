resource "proxmox_vm_qemu" "template" {
  name        = var.template_name
  target_node = var.proxmox_host
  vmid        = var.template_vmid

  agent       = 1
  os_type     = "cloud-init"
  scsihw      = "virtio-scsi-pci"

  # VM Specs
  cores   = 2
  sockets = 1
  cpu     = "host"
  memory  = 2048

  # Network
  network {
    model  = "virtio"
    bridge = var.network_bridge
    tag    = var.network_vlan_tag
  }

  # Cloud-Init
  ciuser  = "ubuntu"
  sshkeys = var.ssh_public_key

  # Template settings
  template = true
}
