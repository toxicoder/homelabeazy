import os
import sys
import unittest

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)
from mapping import to_snake_case, map_vm_to_terraform, map_lxc_to_terraform


class TestMapping(unittest.TestCase):
    def test_to_snake_case(self):
        self.assertEqual(to_snake_case("TestString"), "test_string")
        self.assertEqual(to_snake_case("test-string"), "test_string")
        self.assertEqual(to_snake_case("Test-String"), "test_string")

    def test_map_vm_to_terraform(self):
        vm_data = {
            "name": "test-vm",
            "node": "pve",
            "vmid": 100,
            "maxmem": 2147483648,
            "maxcpu": 2,
            "sockets": 1,
        }
        expected = {
            "resource": "proxmox_vm_qemu",
            "name": "test_vm",
            "attributes": {
                "name": "test-vm",
                "target_node": "pve",
                "vmid": 100,
                "memory": 2048,
                "sockets": 1,
                "cores": 2,
                "os_type": "cloud-init",
            },
        }
        self.assertEqual(map_vm_to_terraform(vm_data), expected)

    def test_map_lxc_to_terraform(self):
        lxc_data = {
            "name": "test-lxc",
            "node": "pve",
            "vmid": 101,
            "maxmem": 1073741824,
            "maxcpu": 1,
        }
        expected = {
            "resource": "proxmox_lxc",
            "name": "test_lxc",
            "attributes": {
                "hostname": "test-lxc",
                "target_node": "pve",
                "vmid": 101,
                "memory": 1024,
                "cores": 1,
            },
        }
        self.assertEqual(map_lxc_to_terraform(lxc_data), expected)

    def test_map_vm_to_terraform_no_memory(self):
        vm_data = {
            "name": "test-vm",
            "node": "pve",
            "vmid": 100,
            "maxcpu": 2,
            "sockets": 1,
        }
        expected = {
            "resource": "proxmox_vm_qemu",
            "name": "test_vm",
            "attributes": {
                "name": "test-vm",
                "target_node": "pve",
                "vmid": 100,
                "memory": 0,
                "sockets": 1,
                "cores": 2,
                "os_type": "cloud-init",
            },
        }
        self.assertEqual(map_vm_to_terraform(vm_data), expected)

    def test_map_lxc_to_terraform_no_memory(self):
        lxc_data = {"name": "test-lxc", "node": "pve", "vmid": 101, "maxcpu": 1}
        expected = {
            "resource": "proxmox_lxc",
            "name": "test_lxc",
            "attributes": {
                "hostname": "test-lxc",
                "target_node": "pve",
                "vmid": 101,
                "memory": 0,
                "cores": 1,
            },
        }
        self.assertEqual(map_lxc_to_terraform(lxc_data), expected)

    def test_map_vm_to_terraform_missing_attributes(self):
        vm_data = {"vmid": 100}
        expected = {
            "resource": "proxmox_vm_qemu",
            "name": "vm_100",
            "attributes": {
                "name": "vm-100",
                "target_node": None,
                "vmid": 100,
                "memory": 0,
                "sockets": 1,
                "cores": 1,
                "os_type": "cloud-init",
            },
        }
        self.assertEqual(map_vm_to_terraform(vm_data), expected)

    def test_map_lxc_to_terraform_missing_attributes(self):
        lxc_data = {"vmid": 101}
        expected = {
            "resource": "proxmox_lxc",
            "name": "lxc_101",
            "attributes": {
                "hostname": "lxc-101",
                "target_node": None,
                "vmid": 101,
                "memory": 0,
                "cores": 1,
            },
        }
        self.assertEqual(map_lxc_to_terraform(lxc_data), expected)


if __name__ == "__main__":
    unittest.main()
