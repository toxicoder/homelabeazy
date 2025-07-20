"""Functions for generating docker-compose files."""

import yaml


def generate_docker_compose(containers: list, filename: str):
    """Generates a docker-compose.yml file."""
    services = {}
    for container in containers:
        service_name = container["name"]
        services[service_name] = {
            "image": container["attributes"]["image"],
            "restart": container["attributes"]["restart"],
            "ports": container["attributes"]["ports"],
        }

    compose_data = {"version": "3.8", "services": services}

    with open(filename, "w") as f:
        yaml.dump(compose_data, f, default_flow_style=False)
