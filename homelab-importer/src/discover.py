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
        if vm_type == "qemu":
            # Command to list Docker containers
            command = "docker ps -a --format '{{json .}}'"
            result = proxmox.nodes(node).qemu(vmid).agent.exec.post(command=command)

            # Command to inspect all containers
            inspect_command = "docker inspect $(docker ps -a -q)"
            inspect_result = proxmox.nodes(node).qemu(vmid).agent.exec.post(command=inspect_command)
        elif vm_type == "lxc":
            # Command to list Docker containers
            command = f"pct exec {vmid} -- docker ps -a --format '{{json .}}'"
            result = proxmox.nodes(node).lxc(vmid).exec.post(command=command)

            # Command to inspect all containers
            inspect_command = f"pct exec {vmid} -- docker inspect $(docker ps -a -q)"
            inspect_result = proxmox.nodes(node).lxc(vmid).exec.post(command=inspect_command)
        else:
            return []

        containers = []
        if result and "stdout" in result:
            for line in result["stdout"].strip().split("\n"):
                containers.append(json.loads(line))

        if inspect_result and "stdout" in inspect_result:
            inspected_data = json.loads(inspect_result["stdout"])
            for i, container in enumerate(containers):
                containers[i]["details"] = inspected_data[i]

        return containers
    except Exception as e:
        print(f"Error getting Docker containers for {vm_type}/{vmid}: {e}")
        return []
