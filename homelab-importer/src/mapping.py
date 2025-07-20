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
    vm_resource = {
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
    if "docker_containers" in vm_data:
        vm_resource["docker_containers"] = [
            map_docker_container_to_compose(c) for c in vm_data["docker_containers"]
        ]
    return vm_resource


def map_docker_container_to_compose(container_data: dict) -> dict:
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
                f'{m["Source"]}:{m["Destination"]}'
                for m in details.get("Mounts", [])
            ],
            "environment": details.get("Config", {}).get("Env", []),
        },
    }


def map_lxc_to_terraform(lxc_data: dict) -> dict:
    """Maps a Proxmox LXC container to a Terraform resource."""
    resource_name = to_snake_case(lxc_data.get("name", "lxc"))
    lxc_resource = {
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
    if "docker_containers" in lxc_data:
        lxc_resource["docker_containers"] = [
            map_docker_container_to_compose(c) for c in lxc_data["docker_containers"]
        ]
    return lxc_resource
