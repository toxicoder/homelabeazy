"""Functions for generating Terraform configuration."""


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

            if "docker_containers" in resource:
                for container in resource["docker_containers"]:
                    f.write(
                        f'resource "{container["resource"]}" "{container["name"]}" {{\n'
                    )
                    for key, value in container["attributes"].items():
                        if isinstance(value, str):
                            f.write(f'  {key} = "{value}"\n')
                        else:
                            f.write(f"  {key} = {value}\n")
                    f.write("}\n\n")
