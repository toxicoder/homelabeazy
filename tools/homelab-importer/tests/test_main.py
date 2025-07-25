import os
import sys
import tempfile
import shutil
import unittest
from unittest.mock import patch, MagicMock

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)
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

    def test_main_missing_env_vars(self):
        # Unset environment variables
        os.environ.pop("PROXMOX_HOST", None)
        os.environ.pop("PROXMOX_USER", None)
        os.environ.pop("PROXMOX_PASSWORD", None)

        with self.assertRaises(SystemExit) as cm:
            main(self.test_dir)
        self.assertEqual(cm.exception.code, 1)

    @patch("main.ProxmoxAPI", side_effect=Exception("Connection Error"))
    def test_main_connection_error(self, mock_proxmox_api):
        # Set environment variables
        os.environ["PROXMOX_HOST"] = "dummy_host"
        os.environ["PROXMOX_USER"] = "dummy_user"
        os.environ["PROXMOX_PASSWORD"] = "dummy_password"

        with self.assertRaises(SystemExit) as cm:
            main(self.test_dir)
        self.assertEqual(cm.exception.code, 1)

    @patch("main.generate_docker_compose")
    @patch("main.get_lxc_containers")
    @patch("main.get_vms")
    @patch("main.ProxmoxAPI")
    def test_main_with_docker_containers(
        self,
        mock_proxmox_api,
        mock_get_vms,
        mock_get_lxc_containers,
        mock_generate_docker_compose,
    ):
        # Set environment variables
        os.environ["PROXMOX_HOST"] = "dummy_host"
        os.environ["PROXMOX_USER"] = "dummy_user"
        os.environ["PROXMOX_PASSWORD"] = "dummy_password"

        # Mock the Proxmox API
        mock_proxmox_instance = MagicMock()
        mock_proxmox_api.return_value = mock_proxmox_instance

        # Mock the return values of the discover functions
        mock_get_vms.return_value = [
            {
                "vmid": 100,
                "name": "test-vm",
                "node": "pve",
                "maxmem": 2147483648,
                "maxcpu": 2,
                "docker_containers": [
                    {
                        "name": "test-container",
                        "attributes": {
                            "image": "test-image",
                            "restart": "always",
                            "ports": [],
                            "volumes": [],
                            "environment": [],
                        },
                    }
                ],
            }
        ]
        mock_get_lxc_containers.return_value = []

        # Run the main function
        main(self.test_dir)

        # Assert that the Docker Compose file was created
        mock_generate_docker_compose.assert_called_once()

    def test_main_no_docker_containers(self):
        # Set environment variables
        os.environ["PROXMOX_HOST"] = "dummy_host"
        os.environ["PROXMOX_USER"] = "dummy_user"
        os.environ["PROXMOX_PASSWORD"] = "dummy_password"

        # Mock the Proxmox API
        mock_proxmox_instance = MagicMock()
        with patch("main.ProxmoxAPI", return_value=mock_proxmox_instance):
            # Mock the return values of the discover functions
            with patch("main.get_vms", return_value=[]):
                with patch("main.get_lxc_containers", return_value=[]):
                    # Run the main function
                    main(self.test_dir)


if __name__ == "__main__":
    unittest.main()
