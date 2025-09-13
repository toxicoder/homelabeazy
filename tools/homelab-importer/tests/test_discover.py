import os
import sys

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)
import unittest
from unittest.mock import MagicMock

from discover import (
    get_docker_containers,
    get_lxc_containers,
    get_vms,
)
from proxmoxer.core import ResourceException


class TestDiscover(unittest.TestCase):
    def test_get_vms(self):
        mock_proxmox = MagicMock()
        mock_proxmox.cluster.resources.get.return_value = [
            {"vmid": 100, "name": "test-vm", "node": "pve"}
        ]

        # Mock the agent exec call to prevent errors
        mock_guest = MagicMock()
        mock_guest.agent.get.return_value = {}
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
        mock_guest.agent.get.return_value = {}
        mock_guest.agent.exec.post.return_value = {"stdout": ""}
        mock_proxmox.nodes.return_value.lxc.return_value = mock_guest

        containers = get_lxc_containers(mock_proxmox)

        self.assertEqual(len(containers), 1)
        self.assertEqual(containers[0]["name"], "test-lxc")
        mock_proxmox.cluster.resources.get.assert_called_with(type="lxc")

    def test_get_vms_error(self):
        mock_proxmox = MagicMock()
        mock_proxmox.cluster.resources.get.side_effect = ResourceException(
            "API Error", "Internal Server Error", 500
        )
        vms = get_vms(mock_proxmox)
        self.assertEqual(len(vms), 0)

    def test_get_lxc_containers_error(self):
        mock_proxmox = MagicMock()
        mock_proxmox.cluster.resources.get.side_effect = ResourceException(
            "API Error", "Internal Server Error", 500
        )
        containers = get_lxc_containers(mock_proxmox)
        self.assertEqual(len(containers), 0)

    def test_get_docker_containers(self):
        mock_proxmox = MagicMock()
        mock_guest = MagicMock()
        mock_guest.agent.get.return_value = {}
        # Mock the three calls to guest.agent.exec.post
        mock_guest.agent.exec.post.side_effect = [
            {"stdout": '{"ID":"123","Names":"test-container"}\n'},
            {"stdout": "123\n"},
            {"stdout": '[{"Id": "123", "Config": {"Env": [], "Mounts": []}}]'},
        ]
        mock_proxmox.nodes.return_value.qemu.return_value = mock_guest

        containers = get_docker_containers(mock_proxmox, "pve", 100, "qemu")
        self.assertEqual(len(containers), 1)
        self.assertEqual(containers[0]["Names"], "test-container")

    def test_get_docker_containers_no_stdout(self):
        mock_proxmox = MagicMock()
        mock_guest = MagicMock()
        mock_guest.agent.get.return_value = {}
        mock_guest.agent.exec.post.return_value = {}
        mock_proxmox.nodes.return_value.qemu.return_value = mock_guest

        containers = get_docker_containers(mock_proxmox, "pve", 100, "qemu")
        self.assertEqual(len(containers), 0)

    def test_get_docker_containers_no_ids(self):
        mock_proxmox = MagicMock()
        mock_guest = MagicMock()
        mock_guest.agent.get.return_value = {}
        mock_guest.agent.exec.post.side_effect = [
            {"stdout": '{"ID":"123","Names":"test-container"}\n'},
            {"stdout": ""},
            {"stdout": ""},
        ]
        mock_proxmox.nodes.return_value.qemu.return_value = mock_guest

        containers = get_docker_containers(mock_proxmox, "pve", 100, "qemu")
        self.assertEqual(len(containers), 1)
        self.assertNotIn("details", containers[0])

    def test_get_docker_containers_lxc(self):
        mock_proxmox = MagicMock()
        mock_guest = MagicMock()
        mock_guest.agent.get.return_value = {}
        # Mock the three calls to guest.agent.exec.post
        mock_guest.agent.exec.post.side_effect = [
            {"stdout": '{"ID":"123","Names":"test-container"}\n'},
            {"stdout": "123\n"},
            {"stdout": '[{"Id": "123", "Config": {"Env": [], "Mounts": []}}]'},
        ]
        mock_proxmox.nodes.return_value.lxc.return_value = mock_guest

        containers = get_docker_containers(mock_proxmox, "pve", 100, "lxc")
        self.assertEqual(len(containers), 1)
        self.assertEqual(containers[0]["Names"], "test-container")

    def test_get_docker_containers_invalid_vm_type(self):
        mock_proxmox = MagicMock()
        containers = get_docker_containers(mock_proxmox, "pve", 100, "kvm")
        self.assertEqual(len(containers), 0)

    def test_get_vms_with_docker_containers(self):
        mock_proxmox = MagicMock()
        mock_proxmox.cluster.resources.get.return_value = [
            {"vmid": 100, "name": "test-vm", "node": "pve"}
        ]
        mock_guest = MagicMock()
        mock_guest.agent.get.return_value = {}
        mock_guest.agent.exec.post.side_effect = [
            {"stdout": '{"ID":"123","Names":"test-container"}\n'},
            {"stdout": "123\n"},
            {"stdout": '[{"Id": "123", "Config": {"Env": [], "Mounts": []}}]'},
        ]
        mock_proxmox.nodes.return_value.qemu.return_value = mock_guest
        vms = get_vms(mock_proxmox)
        self.assertEqual(len(vms), 1)
        self.assertEqual(len(vms[0]["docker_containers"]), 1)

    def test_get_lxc_containers_with_docker_containers(self):
        mock_proxmox = MagicMock()
        mock_proxmox.cluster.resources.get.return_value = [
            {"vmid": 101, "name": "test-lxc", "node": "pve"}
        ]
        mock_guest = MagicMock()
        mock_guest.agent.get.return_value = {}
        mock_guest.agent.exec.post.side_effect = [
            {"stdout": '{"ID":"123","Names":"test-container"}\n'},
            {"stdout": "123\n"},
            {"stdout": '[{"Id": "123", "Config": {"Env": [], "Mounts": []}}]'},
        ]
        mock_proxmox.nodes.return_value.lxc.return_value = mock_guest
        containers = get_lxc_containers(mock_proxmox)
        self.assertEqual(len(containers), 1)
        self.assertEqual(len(containers[0]["docker_containers"]), 1)

    def test_get_vms_with_docker_containers_error(self):
        mock_proxmox = MagicMock()
        mock_proxmox.cluster.resources.get.return_value = [
            {"vmid": 100, "name": "test-vm", "node": "pve"}
        ]
        mock_guest = MagicMock()
        mock_guest.agent.get.return_value = {}
        mock_guest.agent.exec.post.side_effect = ResourceException(
            "Docker error", "Internal Server Error", 500
        )
        mock_proxmox.nodes.return_value.qemu.return_value = mock_guest
        vms = get_vms(mock_proxmox)
        self.assertEqual(len(vms), 1)
        self.assertEqual(len(vms[0]["docker_containers"]), 0)

    def test_get_lxc_containers_with_docker_containers_error(self):
        mock_proxmox = MagicMock()
        mock_proxmox.cluster.resources.get.return_value = [
            {"vmid": 101, "name": "test-lxc", "node": "pve"}
        ]
        mock_guest = MagicMock()
        mock_guest.agent.get.return_value = {}
        mock_guest.agent.exec.post.side_effect = ResourceException(
            "Docker error", "Internal Server Error", 500
        )
        mock_proxmox.nodes.return_value.lxc.return_value = mock_guest
        containers = get_lxc_containers(mock_proxmox)
        self.assertEqual(len(containers), 1)
        self.assertEqual(len(containers[0]["docker_containers"]), 0)

    def test_get_docker_containers_inspect_fails_after_list(self):
        mock_proxmox = MagicMock()
        mock_guest = MagicMock()
        mock_guest.agent.get.return_value = {}
        mock_exec = MagicMock()
        mock_exec.post.side_effect = [
            {"stdout": '{"ID":"123","Names":"test-container"}\n'},
            {"stdout": "123\n"},
            {"stdout": "[]"},
        ]
        mock_guest.agent.exec = mock_exec
        mock_proxmox.nodes.return_value.qemu.return_value = mock_guest

        from discover import get_docker_containers

        containers = get_docker_containers(mock_proxmox, "pve", 100, "qemu")
        self.assertEqual(len(containers), 1)
        self.assertEqual(containers[0]["Names"], "test-container")
        self.assertNotIn("details", containers[0])


if __name__ == "__main__":
    unittest.main()
