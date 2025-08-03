module "k3s_master" {
  source = "../proxmox_vm"

  name        = "k3s-master"
  target_node = var.target_node
  clone       = var.clone
  vmid        = var.master_vmid
  memory      = var.master_memory
  sockets     = var.master_sockets
  cores       = var.master_cores
  os_type     = "cloud-init"
  agent       = var.agent

  networks = [{
    bridge  = var.network_bridge
    macaddr = var.mac
    tag     = var.vlan
  }]
}

module "k3s_worker" {
  count = var.worker_count

  source = "../proxmox_vm"

  name        = "k3s-worker-${count.index}"
  target_node = var.target_node
  clone       = var.clone
  vmid        = var.worker_vmid_start + count.index
  memory      = var.worker_memory
  sockets     = var.worker_sockets
  cores       = var.worker_cores
  os_type     = "cloud-init"
  agent       = var.agent

  networks = [{
    bridge  = var.network_bridge
    macaddr = var.mac
    tag     = var.vlan
  }]
}
