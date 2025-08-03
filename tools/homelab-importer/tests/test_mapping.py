import os
import sys

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)
import unittest

from mapping import map_resource_to_terraform, to_snake_case


class TestMapping(unittest.TestCase):
    def test_to_snake_case(self):
        self.assertEqual(to_snake_case("TestString"), "test_string")
        self.assertEqual(to_snake_case("test-string"), "test_string")
        self.assertEqual(to_snake_case("Test-String"), "test_string")

    def test_map_vm_resource_to_terraform(self):
        vm_data = {
            "name": "example-vm",
            "node": "pve",
            "vmid": 100,
            "maxmem": 2147483648,
            "maxcpu": 2,
            "sockets": 1,
        }
        expected = {
            "resource": "proxmox_vm_qemu",
            "name": "example_vm",
            "attributes": {
                "name": "example-vm",
                "target_node": "pve",
                "vmid": 100,
                "memory": 2048,
                "sockets": 1,
                "cores": 2,
                "os_type": "cloud-init",
            },
        }
        self.assertEqual(map_resource_to_terraform(vm_data, "vm"), expected)

    def test_map_lxc_resource_to_terraform(self):
        lxc_data = {
            "name": "example-lxc",
            "node": "pve",
            "vmid": 101,
            "maxmem": 1073741824,
            "maxcpu": 1,
        }
        expected = {
            "resource": "proxmox_lxc",
            "name": "example_lxc",
            "attributes": {
                "hostname": "example-lxc",
                "target_node": "pve",
                "vmid": 101,
                "memory": 1024,
                "cores": 1,
            },
        }
        self.assertEqual(map_resource_to_terraform(lxc_data, "lxc"), expected)

    def test_map_vm_resource_to_terraform_no_memory(self):
        vm_data = {
            "name": "example-vm",
            "node": "pve",
            "vmid": 100,
            "maxcpu": 2,
            "sockets": 1,
        }
        expected = {
            "resource": "proxmox_vm_qemu",
            "name": "example_vm",
            "attributes": {
                "name": "example-vm",
                "target_node": "pve",
                "vmid": 100,
                "memory": 0,
                "sockets": 1,
                "cores": 2,
                "os_type": "cloud-init",
            },
        }
        self.assertEqual(map_resource_to_terraform(vm_data, "vm"), expected)

    def test_map_lxc_resource_to_terraform_no_memory(self):
        lxc_data = {"name": "example-lxc", "node": "pve", "vmid": 101, "maxcpu": 1}
        expected = {
            "resource": "proxmox_lxc",
            "name": "example_lxc",
            "attributes": {
                "hostname": "example-lxc",
                "target_node": "pve",
                "vmid": 101,
                "memory": 0,
                "cores": 1,
            },
        }
        self.assertEqual(map_resource_to_terraform(lxc_data, "lxc"), expected)

    def test_map_vm_resource_to_terraform_missing_attributes(self):
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
        self.assertEqual(map_resource_to_terraform(vm_data, "vm"), expected)

    def test_map_lxc_resource_to_terraform_missing_attributes(self):
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
        self.assertEqual(map_resource_to_terraform(lxc_data, "lxc"), expected)


if __name__ == "__main__":
    unittest.main()
