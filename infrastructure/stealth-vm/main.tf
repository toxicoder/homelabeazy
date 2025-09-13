resource "proxmox_vm_qemu" "stealth_vm" {
  count = var.stealth_vm_enabled ? 1 : 0

  name        = var.stealth_vm_name
  target_node = var.proxmox_node
  iso         = var.stealth_vm_windows_iso
  onboot      = var.stealth_vm_onboot
  agent       = var.stealth_vm_agent_enabled ? 1 : 0

  # VM Configuration
  bios     = var.stealth_vm_bios
  machine  = var.stealth_vm_machine
  cpu      = var.stealth_vm_cpu
  cores    = var.stealth_vm_cores
  sockets  = var.stealth_vm_sockets
  memory   = var.stealth_vm_memory
  scsihw   = var.stealth_vm_scsihw
  bootdisk = var.stealth_vm_bootdisk

  # Network
  network {
    model   = var.stealth_vm_network_model
    bridge  = var.proxmox_service_bridge
    macaddr = var.stealth_vm_real_mac
  }

  # GPU Passthrough
  hostpci {
    host = var.stealth_vm_gpu_pci_id
    pcie = var.stealth_vm_pcie_enabled ? 1 : 0
  }

  # QEMU Args
  args = "-cpu host,-hypervisor,+kvm_pv_unhalt,+kvm_pv_eoi,hv_spinlocks=0x1fff,hv_vapic,hv_time,hv_reset,hv_vpindex,hv_runtime,hv_relaxed,kvm=off,hv_vendor_id=${var.stealth_vm_hv_vendor_id} -smbios type=1,uuid=${var.smbios_uuid}"

  # SMBIOS
  # smbios {
  #   manufacturer = "ASUS"
  #   product      = "ROG Strix"
  #   uuid         = var.smbios_uuid
  # }
}
