"""Discovery logic for Proxmox resources."""

import json
import logging
from typing import Any, Dict, List
import requests

from proxmoxer import ProxmoxAPI
from proxmoxer.core import ResourceException


def _get_proxmox_resources(
    proxmox: ProxmoxAPI, resource_type: str
) -> List[Dict[str, Any]]:
    """
    Generic function to fetch resources from Proxmox, including their
    Docker containers.
    """
    try:
        resources = proxmox.cluster.resources.get(type=resource_type)
        for resource in resources:
            vm_type = "qemu" if resource_type == "vm" else "lxc"
            resource["docker_containers"] = get_docker_containers(
                proxmox, resource["node"], resource["vmid"], vm_type
            )
        return resources
    except ResourceException as e:
        logging.error(f"Error fetching {resource_type}s: {e}")
        return []


def get_vms(proxmox: ProxmoxAPI) -> List[Dict[str, Any]]:
    """Returns a list of all VMs, including their Docker containers."""
    return _get_proxmox_resources(proxmox, "vm")


def get_lxc_containers(proxmox: ProxmoxAPI) -> List[Dict[str, Any]]:
    """
    Returns a list of all LXC containers, including their Docker containers.
    """
    return _get_proxmox_resources(proxmox, "lxc")


def get_storage_pools(proxmox: ProxmoxAPI) -> List[Dict[str, Any]]:
    """Returns a list of all storage pools."""
    try:
        return proxmox.storage.get()
    except ResourceException as e:
        logging.error(f"Error fetching storage pools: {e}")
        return []


def get_network_bridges(proxmox: ProxmoxAPI) -> List[Dict[str, Any]]:
    """Returns a list of all network bridges."""
    try:
        return proxmox.cluster.resources.get(type="sdn")
    except ResourceException as e:
        logging.error(f"Error fetching network bridges: {e}")
        return []


def get_docker_containers(
    proxmox: ProxmoxAPI, node: str, vmid: int, vm_type: str
) -> List[Dict[str, Any]]:
    """Returns a list of Docker containers running in a VM or LXC."""
    try:
        guest = None
        if vm_type == "qemu":
            guest = proxmox.nodes(node).qemu(vmid)
        elif vm_type == "lxc":
            guest = proxmox.nodes(node).lxc(vmid)
        else:
            return []

        # Fetch container list
        result = guest.agent.exec.post(command="docker ps -a --format '{{json .}}'")
        if not result or "stdout" not in result or not result["stdout"].strip():
            return []
        containers = [
            json.loads(line) for line in result["stdout"].strip().split("\n") if line
        ]

        result = guest.agent.exec.post(command="docker ps -a --format '{{.ID}}'")
        container_ids = []
        if result and "stdout" in result and result["stdout"].strip():
            container_ids = result["stdout"].strip().split("\n")

        # Fetch detailed container info
        if not container_ids:
            return containers

        inspect_result = guest.agent.exec.post(
            command=f"docker inspect {' '.join(container_ids)}"
        )
        if not inspect_result or "stdout" not in inspect_result or not inspect_result["stdout"].strip():
            return containers  # Return basic info if inspect fails

        inspected_data = json.loads(inspect_result["stdout"])
        for i, container in enumerate(containers):
            if i < len(inspected_data):
                container["details"] = inspected_data[i]

        return containers
    except (ResourceException, StopIteration, requests.exceptions.RequestException) as e:
        logging.error(
            f"Error fetching Docker containers for {vm_type}/{vmid} on "
            f"node {node}: {e}"
        )
        return []
    except json.JSONDecodeError as e:
        logging.error(
            f"Error decoding JSON from docker command for {vm_type}/{vmid} "
            f"on node {node}: {e}"
        )
        return []
