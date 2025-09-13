"""Mapping functions for Proxmox to Terraform."""

from typing import Any, Dict

from utils import to_snake_case


def map_resource_to_terraform(
    resource_data: Dict[str, Any], resource_type: str
) -> Dict[str, Any]:
    """Maps a Proxmox resource to a Terraform resource."""
    name = resource_data.get("name")
    if name is None:
        name = f"{resource_type}-{resource_data.get('vmid')}"
    resource_name = to_snake_case(name)
    memory = resource_data.get("maxmem", 0)

    attributes: Dict[str, Any] = {
        "target_node": resource_data.get("node"),
        "vmid": resource_data.get("vmid"),
        "memory": memory // 1024 // 1024,
        "cores": resource_data.get("maxcpu", 1),
    }

    if resource_type == "vm":
        attributes.update(
            {
                "name": name,
                "sockets": resource_data.get("sockets", 1),
                "os_type": "cloud-init",
            }
        )
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
        containers = resource_data["docker_containers"]
        docker_containers = []
        for c in containers:
            mapped_container = map_docker_container_to_compose(c)
            docker_containers.append(mapped_container)
        resource["docker_containers"] = docker_containers
    return resource


def map_docker_container_to_compose(
    container_data: Dict[str, Any],
) -> Dict[str, Any]:
    """Maps a Docker container to a docker-compose service."""
    details = container_data.get("details", {})
    return {
        "name": to_snake_case(container_data.get("Names", "container")),
        "attributes": {
            "image": container_data.get("Image"),
            "restart": "unless-stopped",
            "ports": [
                (
                    f"{p.get('PublicPort', '')}:"
                    f"{p.get('PrivatePort', '')}"
                )
                for p in container_data.get("Ports", [])
            ],
            "volumes": [
                f'{m["Source"]}:{m["Destination"]}'
                for m in details.get("Mounts", [])
            ],
            "environment": details.get("Config", {}).get("Env", []),
        },
    }
