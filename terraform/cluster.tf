# K3s Cluster VMs
# Master Nodes
resource "proxmox_vm_qemu" "k3s_master" {
  count = var.k3s_master_count

  name        = "${var.k3s_master_prefix}-${count.index + 1}"
  target_node = var.proxmox_host
  clone       = var.template_name

  agent   = 1
  os_type = "cloud-init"
  scsihw  = "virtio-scsi-pci"

  # VM Specs
  cores   = var.k3s_master_cpu
  sockets = 1
  cpu     = "host"
  memory  = var.k3s_master_memory

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = var.k3s_master_disk_size
  }

  # Network
  network {
    model  = "virtio"
    bridge = var.network_bridge
    tag    = var.network_vlan_tag
  }

  # Cloud-Init
  ipconfig0 = "ip=${cidrhost(var.network_cidr, count.index + 4)}/24,gw=${var.network_gateway}"
  ciuser    = "ubuntu"
  sshkeys   = var.ssh_public_key
}

# Worker Nodes
resource "proxmox_vm_qemu" "k3s_worker" {
  count = var.k3s_worker_count

  name        = "${var.k3s_worker_prefix}-${count.index + 1}"
  target_node = var.proxmox_host
  clone       = var.template_name

  agent   = 1
  os_type = "cloud-init"
  scsihw  = "virtio-scsi-pci"

  # VM Specs
  cores   = var.k3s_worker_cpu
  sockets = 1
  cpu     = "host"
  memory  = var.k3s_worker_memory

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = var.k3s_worker_disk_size
  }

  # Network
  network {
    model  = "virtio"
    bridge = var.network_bridge
    tag    = var.network_vlan_tag
  }

  # Cloud-Init
  ipconfig0 = "ip=${cidrhost(var.network_cidr, count.index + 4 + var.k3s_master_count)}/24,gw=${var.network_gateway}"
  ciuser    = "ubuntu"
  sshkeys   = var.ssh_public_key
}
