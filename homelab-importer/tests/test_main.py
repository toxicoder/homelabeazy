import unittest
from unittest.mock import patch, MagicMock
import sys
import os
import tempfile
import shutil
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'src')))
from main import main

class TestMain(unittest.TestCase):
    def setUp(self):
        self.test_dir = tempfile.mkdtemp()

    def tearDown(self):
        shutil.rmtree(self.test_dir)

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
        main(self.test_dir)

        # Assert that the Terraform file was created
        with open(os.path.join(self.test_dir, "homelab.tf"), "r") as f:
            content = f.read()
            self.assertIn('resource "proxmox_vm_qemu" "test_vm"', content)
            self.assertIn('resource "proxmox_lxc" "test_lxc"', content)

if __name__ == "__main__":
    unittest.main()
