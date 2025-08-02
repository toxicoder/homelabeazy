"""Functions for generating Terraform configuration."""

import json
import os
from collections import defaultdict
from typing import IO, Any, Dict, List


def get_resource_type_filename(resource_type: str) -> str:
    """Returns the filename for a given resource type."""
    filename_map = {
        "proxmox_vm_qemu": "vms.tf",
        "proxmox_lxc": "lxc.tf",
        "proxmox_storage": "storage.tf",
        "proxmox_network_bridge": "network.tf",
    }
    return filename_map.get(resource_type, "resources.tf")


def generate_terraform_config(resources: List[Dict[str, Any]], output_dir: str) -> None:
    """Generates Terraform configuration files."""
    resources_by_file = defaultdict(list)
    for resource in resources:
        filename = get_resource_type_filename(resource["resource"])
        resources_by_file[filename].append(resource)

    for filename, file_resources in resources_by_file.items():
        filepath = os.path.join(output_dir, filename)
        with open(filepath, "w") as f:
            for resource in file_resources:
                f.write(f'resource "{resource["resource"]}" "{resource["name"]}" {{\n')
                for key, value in resource["attributes"].items():
                    if isinstance(value, str):
                        f.write(f'  {key} = "{value}"\n')
                    else:
                        f.write(f"  {key} = {value}\n")
                f.write("}\n\n")


def generate_terraform_tfvars(
    resources: List[Dict[str, Any]],
    filename: str = "terraform.tfvars",
) -> None:
    """Generates a terraform.tfvars file with structured variables."""
    with open(filename, "w") as f:
        for resource in resources:
            f.write(f'{resource["name"]} = {{\n')
            for key, value in resource["attributes"].items():
                f.write(f'  {key} = "{value}"\n')
            f.write("}\n\n")
            if "docker_containers" in resource:
                generate_docker_tfvars(
                    f, resource["name"], resource["docker_containers"]
                )


def generate_docker_tfvars(
    f: IO[str], resource_name: str, containers: List[Dict[str, Any]]
) -> None:
    """Generates variables for Docker containers."""
    for i, container in enumerate(containers):
        container_name = container.get("name", f"container{i}")
        f.write(f"{resource_name}_{container_name} = {{\n")
        for key, value in container["attributes"].items():
            f.write(f"  {key} = {json.dumps(value)}\n")
        f.write("}\n\n")


def _get_vm_resource_id(resource: Dict[str, Any]) -> str | None:
    """Returns the resource ID for a Proxmox VM."""
    node = resource["attributes"].get("target_node")
    vmid = resource["attributes"].get("vmid")
    if node and vmid:
        return f"{node}/qemu/{vmid}"
    return None


def _get_lxc_resource_id(resource: Dict[str, Any]) -> str | None:
    """Returns the resource ID for a Proxmox LXC container."""
    node = resource["attributes"].get("target_node")
    vmid = resource["attributes"].get("vmid")
    if node and vmid:
        return f"{node}/lxc/{vmid}"
    return None


def _get_storage_resource_id(resource: Dict[str, Any]) -> str | None:
    """Returns the resource ID for a Proxmox storage pool."""
    return resource["attributes"].get("id")


def _get_bridge_resource_id(resource: Dict[str, Any]) -> str | None:
    """Returns the resource ID for a Proxmox network bridge."""
    node = resource["attributes"].get("node")
    bridge_id = resource["attributes"].get("id")
    if node and bridge_id:
        return f"{node}/{bridge_id}"
    return None


def generate_import_script(
    resources: List[Dict[str, Any]], filename: str = "import.sh"
) -> None:
    """Generates a shell script with terraform import commands."""
    resource_id_generators = {
        "proxmox_vm_qemu": _get_vm_resource_id,
        "proxmox_lxc": _get_lxc_resource_id,
        "proxmox_storage": _get_storage_resource_id,
        "proxmox_network_bridge": _get_bridge_resource_id,
    }

    with open(filename, "w") as f:
        f.write("#!/bin/bash\n\n")
        for resource in resources:
            resource_type = resource["resource"]
            resource_name = resource["name"]

            id_generator = resource_id_generators.get(resource_type)
            if not id_generator:
                continue

            resource_id = id_generator(resource)
            if not resource_id:
                continue

            f.write(
                f"terraform import {resource_type}.{resource_name} {resource_id}\n"
            )

    os.chmod(filename, 0o755)
