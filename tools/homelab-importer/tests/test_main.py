import os
import shutil
import sys
import tempfile
import unittest
from unittest.mock import MagicMock, patch

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from exceptions import (  # noqa: E402
    MissingEnvironmentVariableError,
    ProxmoxConnectionError,
)
from main import main  # noqa: E402


class TestMain(unittest.TestCase):
    def setUp(self):
        self.test_dir = tempfile.mkdtemp()
        self.env_vars = {
            "PROXMOX_HOST": "dummy_host",
            "PROXMOX_USER": "dummy_user",
            "PROXMOX_PASSWORD": "dummy_password",
        }
        self.original_env = os.environ.copy()
        os.environ.update(self.env_vars)

    def tearDown(self):
        shutil.rmtree(self.test_dir)
        os.environ.clear()
        os.environ.update(self.original_env)

    @patch("main.ProxmoxAPI")
    def test_main_success(self, mock_proxmox_api):
        mock_proxmox_instance = MagicMock()
        mock_proxmox_api.return_value = mock_proxmox_instance
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
            [],
        ]
        mock_proxmox_instance.storage.get.return_value = []

        main(self.test_dir)

        self.assertTrue(os.path.isdir(self.test_dir))
        tf_files = [f for f in os.listdir(self.test_dir) if f.endswith(".tf")]
        self.assertTrue(tf_files)

    def test_main_missing_env_vars(self):
        os.environ.clear()
        with self.assertRaises(MissingEnvironmentVariableError):
            main(self.test_dir)

    @patch(
        "main.ProxmoxAPI",
        side_effect=ProxmoxConnectionError("Connection Error"),
    )
    def test_main_connection_error(self, mock_proxmox_api):
        with self.assertRaises(ProxmoxConnectionError):
            main(self.test_dir)

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
        mock_proxmox_instance = MagicMock()
        mock_proxmox_api.return_value = mock_proxmox_instance
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

        main(self.test_dir)

        mock_generate_docker_compose.assert_called_once()

    @patch("main.get_lxc_containers")
    @patch("main.get_vms")
    @patch("main.ProxmoxAPI")
    def test_main_no_docker_containers(
        self, mock_proxmox_api, mock_get_vms, mock_get_lxc_containers
    ):
        mock_proxmox_instance = MagicMock()
        mock_proxmox_api.return_value = mock_proxmox_instance
        mock_get_vms.return_value = []
        mock_get_lxc_containers.return_value = []

        main(self.test_dir)


if __name__ == "__main__":
    unittest.main()
