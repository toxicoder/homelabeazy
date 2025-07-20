import unittest
from unittest.mock import patch, MagicMock
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'src')))
from main import main

import os

class TestMain(unittest.TestCase):
    @patch("main.ProxmoxAPI")
    def test_main_success(self, mock_proxmox_api):
        # Set environment variables
        os.environ["PROXMOX_HOST"] = "dummy_host"
        os.environ["PROXMOX_USER"] = "dummy_user"
        os.environ["PROXMOX_PASSWORD"] = "dummy_password"

        # Mock the Proxmox API
        mock_proxmox_instance = MagicMock()
        mock_proxmox_api.return_value = mock_proxmox_instance

        # Mock the return values of the discover functions
        mock_proxmox_instance.cluster.resources.get.side_effect = [
            [
                {
                    "vmid": 100,
                    "name": "test-vm",
                    "node": "pve",
                    "maxmem": 2147483648,
                    "maxcpu": 2,
                }
            ],
            [
                {
                    "vmid": 101,
                    "name": "test-lxc",
                    "node": "pve",
                    "maxmem": 1073741824,
                    "maxcpu": 1,
                }
            ],
        ]

        # Run the main function
        main()

        # Assert that the Terraform file was created
        with open("homelab.tf", "r") as f:
            content = f.read()
            self.assertIn('resource "proxmox_vm_qemu" "test_vm"', content)
            self.assertIn('resource "proxmox_lxc" "test_lxc"', content)

        # Clean up the generated file
        os.remove("homelab.tf")

if __name__ == "__main__":
    unittest.main()
