"""Functions for generating Terraform configuration."""

import os


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
    """Generates a terraform.tfvars file."""
    with open(filename, "w") as f:
        for resource in resources:
            for key, value in resource["attributes"].items():
                var_name = f'{resource["name"]}_{key}'
                f.write(f'{var_name} = "{value}"\n')


def generate_import_script(resources: list, filename: str = "import.sh"):
    """Generates a shell script with terraform import commands."""
    with open(filename, "w") as f:
        f.write("#!/bin/bash\n\n")
        for resource in resources:
            resource_type = resource["resource"]
            resource_name = resource["name"]
            resource_id = resource.get(
                "id"
            )  # Assuming 'id' is available in the resource data
            if resource_id:
                f.write(
                    f"terraform import {resource_type}.{resource_name} {resource_id}\n"
                )
