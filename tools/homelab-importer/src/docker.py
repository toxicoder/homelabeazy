"""Functions for generating docker-compose files."""

from typing import Any, Dict, List

import yaml


def generate_docker_compose(containers: List[Dict[str, Any]], filename: str) -> None:
    """Generates a docker-compose.yml file."""
    services = {}
    for container in containers:
        service_name = container["name"]
        services[service_name] = {
            "image": container["attributes"]["image"],
            "restart": container["attributes"]["restart"],
            "ports": container["attributes"]["ports"],
            "volumes": container["attributes"]["volumes"],
            "environment": container["attributes"]["environment"],
        }

    compose_data = {"version": "3.8", "services": services}

    with open(filename, "w") as f:
        yaml.dump(compose_data, f, default_flow_style=False)
