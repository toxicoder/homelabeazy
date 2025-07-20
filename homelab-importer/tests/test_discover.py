import unittest
from unittest.mock import MagicMock
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'src')))
from discover import get_vms, get_lxc_containers

class TestDiscover(unittest.TestCase):
    def test_get_vms(self):
        mock_proxmox = MagicMock()
        mock_proxmox.cluster.resources.get.return_value = [
            {"vmid": 100, "name": "test-vm", "node": "pve"}
        ]

        # Mock the agent exec call to prevent errors
        mock_guest = MagicMock()
        mock_guest.agent.exec.post.return_value = {"stdout": ""}
        mock_proxmox.nodes.return_value.qemu.return_value = mock_guest

        vms = get_vms(mock_proxmox)

        self.assertEqual(len(vms), 1)
        self.assertEqual(vms[0]["name"], "test-vm")
        mock_proxmox.cluster.resources.get.assert_called_with(type="vm")

    def test_get_lxc_containers(self):
        mock_proxmox = MagicMock()
        mock_proxmox.cluster.resources.get.return_value = [
            {"vmid": 101, "name": "test-lxc", "node": "pve"}
        ]

        # Mock the agent exec call to prevent errors
        mock_guest = MagicMock()
        mock_guest.agent.exec.post.return_value = {"stdout": ""}
        mock_proxmox.nodes.return_value.lxc.return_value = mock_guest

        containers = get_lxc_containers(mock_proxmox)

        self.assertEqual(len(containers), 1)
        self.assertEqual(containers[0]["name"], "test-lxc")
        mock_proxmox.cluster.resources.get.assert_called_with(type="lxc")

if __name__ == "__main__":
    unittest.main()
