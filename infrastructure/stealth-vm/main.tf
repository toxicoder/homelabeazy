resource "proxmox_vm_qemu" "stealth_vm" {
  count = var.enable_stealth_vm ? 1 : 0

  name        = "stealth-vm"
  target_node = var.proxmox_host
  iso         = var.windows_iso
  onboot      = true
  agent       = 1

  # VM Configuration
  bios     = var.bios
  machine  = var.machine
  cpu      = var.cpu
  cores    = var.cores
  sockets  = 1
  memory   = var.memory
  scsihw   = var.scsihw
  bootdisk = var.bootdisk

  # Network
  network {
    model  = var.network_model
    bridge = var.network_bridge
    macaddr = var.real_mac
  }

  # GPU Passthrough
  hostpci {
    host = var.gpu_pci_id
    pcie = 1
  }

  # QEMU Args
  args = "-cpu host,-hypervisor,+kvm_pv_unhalt,+kvm_pv_eoi,hv_spinlocks=0x1fff,hv_vapic,hv_time,hv_reset,hv_vpindex,hv_runtime,hv_relaxed,kvm=off,hv_vendor_id=${var.hv_vendor_id}"

  # SMBIOS
  smbios {
    manufacturer = var.smbios_manufacturer
    product      = var.smbios_product
    uuid         = var.smbios_uuid
  }
}
