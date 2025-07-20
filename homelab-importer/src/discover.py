"""Discovery logic for Proxmox resources."""

import json
from proxmoxer import ProxmoxAPI

def get_vms(proxmox: ProxmoxAPI):
    """Returns a list of all VMs."""
    return proxmox.cluster.resources.get(type='vm')

def get_lxc_containers(proxmox: ProxmoxAPI):
    """Returns a list of all LXC containers."""
    return proxmox.cluster.resources.get(type='lxc')

def get_storage_pools(proxmox: ProxmoxAPI):
    """Returns a list of all storage pools."""
    return proxmox.storage.get()

def get_network_bridges(proxmox: ProxmoxAPI):
    """Returns a list of all network bridges."""
    return proxmox.cluster.resources.get(type='sdn')


def get_docker_containers(proxmox: ProxmoxAPI, node: str, vmid: int, vm_type: str):
    """Returns a list of Docker containers running in a VM or LXC."""
    try:
        # Determine the guest type and prepare the command
        if vm_type == "qemu":
            guest = proxmox.nodes(node).qemu(vmid)
            command = "docker ps -a --format '{{json .}}'"
            inspect_command = "docker inspect $(docker ps -a -q)"
        elif vm_type == "lxc":
            guest = proxmox.nodes(node).lxc(vmid)
            command = "docker ps -a --format '{{json .}}'"
            inspect_command = "docker inspect $(docker ps -a -q)"
        else:
            return []

        # Execute the command to get the list of containers
        result = guest.agent.exec.post(command=command)
        if not result or "stdout" not in result:
            return []

        containers = [json.loads(line) for line in result["stdout"].strip().split("\n")]

        # Execute the command to inspect the containers
        inspect_result = guest.agent.exec.post(command=inspect_command)
        if not inspect_result or "stdout" not in inspect_result:
            return containers

        inspected_data = json.loads(inspect_result["stdout"])
        for i, container in enumerate(containers):
            containers[i]["details"] = inspected_data[i]

        return containers
    except Exception as e:
        print(f"Error getting Docker containers for {vm_type}/{vmid}: {e}")
        return []
