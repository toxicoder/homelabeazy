resource "proxmox_vm_qemu" "template" {
  name        = var.template_name
  target_node = var.proxmox_host
  vmid        = var.template_vmid
  clone       = var.template_name

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
  ipconfig0 = "ip=dhcp"
  ciuser    = "ubuntu"
  sshkeys   = "ssh-rsa ..."

  # Template settings
  template = true
}
