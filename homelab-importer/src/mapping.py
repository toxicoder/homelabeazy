"""Mapping functions for Proxmox to Terraform."""
import re


def to_snake_case(name):
    """Converts a string to snake_case."""
    name = re.sub("(.)([A-Z][a-z]+)", r"\1_\2", name)
    name = re.sub("([a-z0-9])([A-Z])", r"\1_\2", name)
    return name.lower().replace("-", "_")


def map_vm_to_terraform(vm_data: dict) -> dict:
    """Maps a Proxmox VM to a Terraform resource."""
    resource_name = to_snake_case(vm_data.get("name", "vm"))
    return {
        "resource": "proxmox_vm_qemu",
        "name": resource_name,
        "attributes": {
            "name": vm_data.get("name"),
            "target_node": vm_data.get("node"),
            "vmid": vm_data.get("vmid"),
            "memory": vm_data.get("maxmem") // 1024 // 1024,
            "sockets": vm_data.get("sockets", 1),
            "cores": vm_data.get("maxcpu", 1),
            "os_type": "cloud-init",
        },
    }


def map_lxc_to_terraform(lxc_data: dict) -> dict:
    """Maps a Proxmox LXC container to a Terraform resource."""
    resource_name = to_snake_case(lxc_data.get("name", "lxc"))
    return {
        "resource": "proxmox_lxc",
        "name": resource_name,
        "attributes": {
            "hostname": lxc_data.get("name"),
            "target_node": lxc_data.get("node"),
            "vmid": lxc_data.get("vmid"),
            "memory": lxc_data.get("maxmem") // 1024 // 1024,
            "cores": lxc_data.get("maxcpu", 1),
        },
    }
