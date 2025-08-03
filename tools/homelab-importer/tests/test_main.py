import os
import shutil
import sys
import tempfile

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)
import unittest
from unittest.mock import MagicMock, patch

from exceptions import (
    MissingEnvironmentVariableError,
    ProxmoxConnectionError,
)
from main import main


class TestMain(unittest.TestCase):
    def setUp(self):
        self.test_dir = tempfile.mkdtemp()
        self.env_vars = {
            "PROXMOX_HOST": "dummy_host",
            "PROXMOX_USER": "dummy_user",
            "VAULT_ADDR": "dummy_addr",
            "VAULT_TOKEN": "dummy_token",
        }
        self.original_env = os.environ.copy()
        os.environ.update(self.env_vars)

    def tearDown(self):
        shutil.rmtree(self.test_dir)
        os.environ.clear()
        os.environ.update(self.original_env)

    @patch("main.hvac.Client")
    @patch("main.ProxmoxAPI")
    def test_main_success(self, mock_proxmox_api, mock_hvac_client):
        mock_hvac_client.return_value.secrets.kv.v2.read_secret_version.return_value = {
            "data": {"data": {"password": "dummy_password"}}
        }
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

        terraform_dir = os.path.join(self.test_dir, "terraform")
        self.assertTrue(os.path.isdir(terraform_dir))
        self.assertTrue(any(f.endswith(".tf") for f in os.listdir(terraform_dir)))

    def test_main_missing_env_vars(self):
        os.environ.clear()
        with self.assertRaises(MissingEnvironmentVariableError):
            main(self.test_dir)

    @patch("main.hvac.Client")
    @patch(
        "main.ProxmoxAPI",
        side_effect=ProxmoxConnectionError("Connection Error"),
    )
    def test_main_connection_error(self, mock_proxmox_api, mock_hvac_client):
        mock_hvac_client.return_value.secrets.kv.v2.read_secret_version.return_value = {
            "data": {"data": {"password": "dummy_password"}}
        }
        with self.assertRaises(ProxmoxConnectionError):
            main(self.test_dir)

    @patch("main.generate_docker_compose")
    @patch("main.get_lxc_containers")
    @patch("main.get_vms")
    @patch("main.hvac.Client")
    @patch("main.ProxmoxAPI")
    def test_main_with_docker_containers(
        self,
        mock_proxmox_api,
        mock_hvac_client,
        mock_get_vms,
        mock_get_lxc_containers,
        mock_generate_docker_compose,
    ):
        mock_hvac_client.return_value.secrets.kv.v2.read_secret_version.return_value = {
            "data": {"data": {"password": "dummy_password"}}
        }
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
    @patch("main.hvac.Client")
    def test_main_no_docker_containers(self, mock_hvac_client, mock_proxmox_api, mock_get_vms, mock_get_lxc_containers):
        mock_hvac_client.return_value.secrets.kv.v2.read_secret_version.return_value = {
            "data": {"data": {"password": "dummy_password"}}
        }
        mock_proxmox_instance = MagicMock()
        mock_proxmox_api.return_value = mock_proxmox_instance
        mock_get_vms.return_value = []
        mock_get_lxc_containers.return_value = []

        main(self.test_dir)


if __name__ == "__main__":
    unittest.main()
