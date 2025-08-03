resource "proxmox_vm_qemu" "stealth_vm" {
  count = var.enable_stealth_vm ? 1 : 0

  name        = "stealth-vm"
  target_node = var.target_node
  iso         = var.windows_iso
  onboot      = true
  agent       = 1

  # VM Configuration
  bios     = "ovmf"
  machine  = "q35"
  cpu      = "host"
  cores    = 4
  sockets  = 1
  memory   = 8192
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  # Network
  network {
    model   = "e1000"
    bridge  = var.service_bridge
    macaddr = var.real_mac
  }

  # GPU Passthrough
  hostpci {
    host = var.gpu_pci_id
    pcie = 1
  }

  # QEMU Args
  args = "-cpu host,-hypervisor,+kvm_pv_unhalt,+kvm_pv_eoi,hv_spinlocks=0x1fff,hv_vapic,hv_time,hv_reset,hv_vpindex,hv_runtime,hv_relaxed,kvm=off,hv_vendor_id=${var.hv_vendor_id}"
}
