module "k3s-master" {
  source = "../instance"

  instance_type  = "qemu"
  name           = "k3s-master"
  target_node    = var.target_node
  clone          = var.clone
  vmid           = var.master_vm_id
  memory         = var.master_memory
  sockets        = var.master_sockets
  cores          = var.master_cores
  agent          = var.agent
  network_bridge = var.network_bridge
  mac            = var.mac
  vlan_tag       = var.vlan_tag
}

module "k3s-worker" {
  source = "../instance"
  count  = var.worker_count

  instance_type  = "qemu"
  name           = "k3s-worker-${count.index}"
  target_node    = var.target_node
  clone          = var.clone
  vmid           = var.worker_vm_id_start + count.index
  memory         = var.worker_memory
  sockets        = var.worker_sockets
  cores          = var.worker_cores
  agent          = var.agent
  network_bridge = var.network_bridge
  mac            = var.mac
  vlan_tag       = var.vlan_tag
}
