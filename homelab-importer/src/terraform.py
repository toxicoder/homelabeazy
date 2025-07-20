"""Functions for generating Terraform configuration."""

import os
import json


def generate_terraform_config(resources: list, filename: str):
    """Generates a Terraform configuration file."""
    with open(filename, "w") as f:
        for resource in resources:
            f.write(f'resource "{resource["resource"]}" "{resource["name"]}" {{\n')
            for key, value in resource["attributes"].items():
                if isinstance(value, str):
                    f.write(f'  {key} = "{value}"\n')
                else:
                    f.write(f"  {key} = {value}\n")
            f.write("}\n\n")


def generate_terraform_tfvars(resources: list, filename: str = "terraform.tfvars"):
    """Generates a terraform.tfvars file with structured variables."""
    with open(filename, "w") as f:
        for resource in resources:
            f.write(f'{resource["name"]} = {{\n')
            for key, value in resource["attributes"].items():
                f.write(f'  {key} = "{value}"\n')
            f.write("}\n\n")
            if "docker_containers" in resource:
                generate_docker_tfvars(f, resource["name"], resource["docker_containers"])


def generate_docker_tfvars(f, resource_name: str, containers: list):
    """Generates variables for Docker containers."""
    for i, container in enumerate(containers):
        container_name = container.get("name", f"container{i}")
        f.write(f'{resource_name}_{container_name} = {{\n')
        for key, value in container["attributes"].items():
            f.write(f'  {key} = {json.dumps(value)}\n')
        f.write("}\n\n")


def generate_import_script(resources: list, filename: str = "import.sh"):
    """Generates a shell script with terraform import commands."""
    with open(filename, "w") as f:
        f.write("#!/bin/bash\n\n")
        for resource in resources:
            resource_type = resource["resource"]
            resource_name = resource["name"]
            # Construct the Proxmox resource ID
            node = resource["attributes"].get("target_node")
            vmid = resource["attributes"].get("vmid")
            if resource_type == "proxmox_vm_qemu":
                resource_id = f"{node}/qemu/{vmid}"
                f.write(
                    f"terraform import {resource_type}.{resource_name} {resource_id}\n"
                )
            elif resource_type == "proxmox_lxc":
                resource_id = f"{node}/lxc/{vmid}"
                f.write(
                    f"terraform import {resource_type}.{resource_name} {resource_id}\n"
                )
