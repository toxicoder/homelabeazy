output "ansible_inventory" {
  sensitive = true
  value = {
    k3s_masters = {
      hosts = {
        for vm in proxmox_vm_qemu.k3s_master :
        vm.name => {
          ansible_host = cidrhost(var.network_cidr, index(proxmox_vm_qemu.k3s_master.*.name, vm.name) + 4)
        }
      }
    }
    k3s_workers = {
      hosts = {
        for vm in proxmox_vm_qemu.k3s_worker :
        vm.name => {
          ansible_host = cidrhost(var.network_cidr, index(proxmox_vm_qemu.k3s_worker.*.name, vm.name) + 4 + var.k3s_master_count)
        }
      }
    }
  }
}

resource "local_file" "ansible_inventory" {
  content  = yamlencode(output.ansible_inventory)
  filename = "../ansible/inventory/inventory.auto.yml"
}
