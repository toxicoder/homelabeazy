"""Discovery logic for Proxmox resources."""

import json
import logging
from typing import Any, Dict, List

from proxmoxer import ProxmoxAPI
from proxmoxer.core import ResourceException


def get_vms(proxmox: ProxmoxAPI) -> List[Dict[str, Any]]:
    """Returns a list of all VMs, including their Docker containers."""
    try:
        vms = proxmox.cluster.resources.get(type="vm")
        for vm in vms:
            vm["docker_containers"] = get_docker_containers(
                proxmox, vm["node"], vm["vmid"], "qemu"
            )
        return vms
    except ResourceException as e:
        logging.error(f"Error fetching VMs: {e}")
        return []


def get_lxc_containers(proxmox: ProxmoxAPI) -> List[Dict[str, Any]]:
    """
    Returns a list of all LXC containers, including their Docker containers.
    """
    try:
        containers = proxmox.cluster.resources.get(type="lxc")
        for container in containers:
            container["docker_containers"] = get_docker_containers(
                proxmox, container["node"], container["vmid"], "lxc"
            )
        return containers
    except ResourceException as e:
        logging.error(f"Error fetching LXC containers: {e}")
        return []


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

        # Check for guest agent readiness
        try:
            guest.agent.get('info')
        except Exception:
            logging.debug(f"Guest agent not running or responding in {vm_type}/{vmid} on node {node}.")
            return []


        # Fetch container list
        result = guest.agent.exec.post(command="docker ps -a --format '{{json .}}'")
        if not result or "stdout" not in result or not result["stdout"]:
            logging.debug(f"No docker containers found in {vm_type}/{vmid} on node {node}")
            return []
        containers = [
            json.loads(line) for line in result["stdout"].strip().split("\n") if line
        ]

        result = guest.agent.exec.post(command="docker ps -a --format '{{.ID}}'")
        if not result or "stdout" not in result or not result["stdout"]:
            return containers # Return basic info if we can't get IDs
        container_ids = result["stdout"].strip().split("\n")


        # Fetch detailed container info
        inspect_result = guest.agent.exec.post(
            command=f"docker inspect {' '.join(container_ids)}"
        )
        if not inspect_result or "stdout" not in inspect_result:
            logging.warning(f"Could not inspect Docker containers in {vm_type}/{vmid}")
            return containers  # Return basic info if inspect fails

        inspected_data = json.loads(inspect_result["stdout"])
        for i, container in enumerate(containers):
            if i < len(inspected_data):
                container["details"] = inspected_data[i]

        return containers
    except (ResourceException, StopIteration, Exception) as e:
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
