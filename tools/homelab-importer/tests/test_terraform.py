import os
import sys
import unittest
from unittest.mock import mock_open, patch, call

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)
from terraform import (
    generate_terraform_config,
    generate_terraform_tfvars,
    generate_import_script,
)


class TestTerraform(unittest.TestCase):
    def test_generate_terraform_config(self):
        resources = [
            {
                "resource": "proxmox_vm_qemu",
                "name": "test-vm",
                "attributes": {
                    "name": "test-vm",
                    "target_node": "pve",
                    "vmid": 100,
                    "memory": 2048,
                },
            }
        ]

        m = mock_open()
        with patch("builtins.open", m):
            generate_terraform_config(resources, "homelab.tf")

        m.assert_called_once_with("homelab.tf", "w")
        handle = m()
        handle.write.assert_any_call(
            'resource "proxmox_vm_qemu" "test-vm" {\n'
        )
        handle.write.assert_any_call('  name = "test-vm"\n')
        handle.write.assert_any_call('  target_node = "pve"\n')
        handle.write.assert_any_call("  vmid = 100\n")
        handle.write.assert_any_call("  memory = 2048\n")
        handle.write.assert_any_call("}\n\n")

    def test_generate_terraform_tfvars(self):
        resources = [
            {
                "resource": "proxmox_vm_qemu",
                "name": "test-vm",
                "attributes": {"name": "test-vm", "target_node": "pve"},
            }
        ]

        m = mock_open()
        with patch("builtins.open", m):
            generate_terraform_tfvars(resources, "terraform.tfvars")

        m.assert_called_once_with("terraform.tfvars", "w")
        handle = m()
        handle.write.assert_any_call("test-vm = {\n")
        handle.write.assert_any_call('  name = "test-vm"\n')
        handle.write.assert_any_call('  target_node = "pve"\n')
        handle.write.assert_any_call("}\n\n")

    def test_generate_import_script(self):
        resources = [
            {
                "resource": "proxmox_vm_qemu",
                "name": "test-vm",
                "attributes": {"target_node": "pve", "vmid": 100},
            },
            {
                "resource": "proxmox_lxc",
                "name": "test-lxc",
                "attributes": {"target_node": "pve", "vmid": 101},
            },
        ]

        m = mock_open()
        with patch("builtins.open", m):
            generate_import_script(resources, "import.sh")

        m.assert_called_once_with("import.sh", "w")
        handle = m()
        handle.write.assert_any_call("#!/bin/bash\n\n")
        calls = [
            call("terraform import proxmox_vm_qemu.test-vm pve/qemu/100\n"),
            call("terraform import proxmox_lxc.test-lxc pve/lxc/101\n"),
        ]
        handle.write.assert_has_calls(calls, any_order=True)

    def test_generate_import_script_no_node(self):
        resources = [
            {
                "resource": "proxmox_vm_qemu",
                "name": "test-vm",
                "attributes": {"vmid": 100},
            }
        ]

        m = mock_open()
        with patch("builtins.open", m):
            generate_import_script(resources, "import.sh")

        m.assert_called_once_with("import.sh", "w")
        handle = m()
        handle.write.assert_any_call("#!/bin/bash\n\n")
        self.assertEqual(handle.write.call_count, 1)


if __name__ == "__main__":
    unittest.main()
