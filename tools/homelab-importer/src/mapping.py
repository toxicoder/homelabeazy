"""Mapping functions for Proxmox to Terraform."""

from typing import Any, Dict

from utils import to_snake_case


def _map_resource_to_terraform(
    resource_data: Dict[str, Any], resource_type: str
) -> Dict[str, Any]:
    """Maps a Proxmox resource to a Terraform resource."""
    name = resource_data.get("name")
    if name is None:
        name = f"{resource_type}-{resource_data.get('vmid')}"
    resource_name = to_snake_case(name)
    memory = resource_data.get("maxmem")
    if memory is None:
        memory = 0

    attributes: Dict[str, Any] = {
        "target_node": resource_data.get("node"),
        "vmid": resource_data.get("vmid"),
        "memory": memory // 1024 // 1024,
        "cores": resource_data.get("maxcpu", 1),
    }

    if resource_type == "vm":
        attributes["name"] = name
        attributes["sockets"] = resource_data.get("sockets", 1)
        attributes["os_type"] = "cloud-init"
        resource_key = "proxmox_vm_qemu"
    else:
        attributes["hostname"] = name
        resource_key = "proxmox_lxc"

    resource: Dict[str, Any] = {
        "resource": resource_key,
        "name": resource_name,
        "attributes": attributes,
    }

    if "docker_containers" in resource_data:
        resource["docker_containers"] = [
            map_docker_container_to_compose(c)
            for c in resource_data["docker_containers"]
        ]
    return resource


def map_vm_to_terraform(vm_data: Dict[str, Any]) -> Dict[str, Any]:
    """Maps a Proxmox VM to a Terraform resource."""
    return _map_resource_to_terraform(vm_data, "vm")


def map_docker_container_to_compose(container_data: Dict[str, Any]) -> Dict[str, Any]:
    """Maps a Docker container to a docker-compose service."""
    details = container_data.get("details", {})
    return {
        "name": to_snake_case(container_data.get("Names", "container")),
        "attributes": {
            "image": container_data.get("Image"),
            "restart": "unless-stopped",
            "ports": [
                f'{p.get("PublicPort", "")}:{p.get("PrivatePort", "")}'
                for p in container_data.get("Ports", [])
            ],
            "volumes": [
                f'{m["Source"]}:{m["Destination"]}' for m in details.get("Mounts", [])
            ],
            "environment": details.get("Config", {}).get("Env", []),
        },
    }


def map_lxc_to_terraform(lxc_data: Dict[str, Any]) -> Dict[str, Any]:
    """Maps a Proxmox LXC container to a Terraform resource."""
    return _map_resource_to_terraform(lxc_data, "lxc")
