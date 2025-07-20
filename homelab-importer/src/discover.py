"""Discovery logic for Proxmox resources."""

import json
from proxmoxer import ProxmoxAPI


def get_vms(proxmox: ProxmoxAPI):
    """Returns a list of all VMs, including their Docker containers."""
    vms = proxmox.cluster.resources.get(type="vm")
    for vm in vms:
        vm["docker_containers"] = get_docker_containers(
            proxmox, vm["node"], vm["vmid"], "qemu"
        )
    return vms


def get_lxc_containers(proxmox: ProxmoxAPI):
    """Returns a list of all LXC containers, including their Docker containers."""
    containers = proxmox.cluster.resources.get(type="lxc")
    for container in containers:
        container["docker_containers"] = get_docker_containers(
            proxmox, container["node"], container["vmid"], "lxc"
        )
    return containers


def get_storage_pools(proxmox: ProxmoxAPI):
    """Returns a list of all storage pools."""
    return proxmox.storage.get()


def get_network_bridges(proxmox: ProxmoxAPI):
    """Returns a list of all network bridges."""
    return proxmox.cluster.resources.get(type="sdn")


def get_docker_containers(proxmox: ProxmoxAPI, node: str, vmid: int, vm_type: str):
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
        if not result or "stdout" not in result:
            return []
        containers = [
            json.loads(line) for line in result["stdout"].strip().split("\n") if line
        ]

        result = guest.agent.exec.post(command="docker ps -a --format '{{.ID}}'")
        if not result or "stdout" not in result:
            return []
        container_ids = result['stdout'].strip().split('\n')
        if not container_ids:
            return []

        # Fetch detailed container info
        inspect_result = guest.agent.exec.post(
            command="docker inspect " + " ".join(container_ids)
        )
        if not inspect_result or "stdout" not in inspect_result:
            return containers  # Return basic info if inspect fails

        inspected_data = json.loads(inspect_result["stdout"])
        for i, container in enumerate(containers):
            if i < len(inspected_data):
                container["details"] = inspected_data[i]

        return containers
    except Exception as e:
        print(f"An error occurred while fetching Docker containers: {e}")
        return []
