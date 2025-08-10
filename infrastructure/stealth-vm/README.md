# Terraform Module: stealth-vm

This module creates a "stealth" VM in Proxmox, which is configured to be difficult to detect as a virtual machine. This is useful for game streaming and other applications that may not work well in a virtualized environment.

**Note:** This module is intended to ensure compatibility and performance for legitimate use cases. It is not designed to enable or facilitate cheating in any way.

## Usage

```terraform
module "stealth-vm" {
  source = "./stealth-vm"

  stealth_vm_enabled       = true
  proxmox_node             = "pve"
  stealth_vm_windows_iso   = "/path/to/windows.iso"
  stealth_vm_gpu_pci_id    = "0000:01:00.0"
  # ... other variables
}
```

## Variables

See `variables.tf` for a full list of available variables.

## Outputs

See `outputs.tf` for a list of outputs.
