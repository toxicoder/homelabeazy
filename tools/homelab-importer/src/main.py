import argparse
import logging
import os

from dotenv import load_dotenv
from proxmoxer import ProxmoxAPI
from proxmoxer.core import AuthenticationError as ProxmoxerAuthenticationError

from discover import get_lxc_containers, get_network_bridges, get_storage_pools, get_vms
from docker import generate_docker_compose
from exceptions import (
    HomelabImporterError,
    MissingEnvironmentVariableError,
    ProxmoxAuthenticationError,
    ProxmoxConnectionError,
)
from mapping import (
    map_lxc_to_terraform,
    map_network_bridge_to_terraform,
    map_storage_pool_to_terraform,
    map_vm_to_terraform,
)
from terraform import (
    generate_import_script,
    generate_terraform_config,
    generate_terraform_tfvars,
)


def main(output_dir: str) -> None:
    """Connects to Proxmox and generates Terraform configuration."""
    load_dotenv()

    proxmox_host = os.getenv("PROXMOX_HOST")
    proxmox_user = os.getenv("PROXMOX_USER")
    proxmox_password = os.getenv("PROXMOX_PASSWORD")

    if not all([proxmox_host, proxmox_user, proxmox_password]):
        raise MissingEnvironmentVariableError(
            "PROXMOX_HOST, PROXMOX_USER, and PROXMOX_PASSWORD must be set as "
            "environment variables or in a .env file."
        )

    try:
        proxmox = ProxmoxAPI(
            proxmox_host,
            user=proxmox_user,
            password=proxmox_password,
            verify_ssl=True,
        )
        logging.info("Successfully connected to Proxmox!")

        vms = get_vms(proxmox)
        lxc_containers = get_lxc_containers(proxmox)
        storage_pools = get_storage_pools(proxmox)
        network_bridges = get_network_bridges(proxmox)

        terraform_vms = [map_vm_to_terraform(vm) for vm in vms]
        terraform_lxc_containers = [map_lxc_to_terraform(c) for c in lxc_containers]
        terraform_storage_pools = [
            map_storage_pool_to_terraform(s) for s in storage_pools
        ]
        terraform_network_bridges = [
            map_network_bridge_to_terraform(b) for b in network_bridges
        ]

        all_resources = (
            terraform_vms
            + terraform_lxc_containers
            + terraform_storage_pools
            + terraform_network_bridges
        )

        # Create output directories
        terraform_dir = os.path.join(output_dir, "terraform")
        docker_dir = os.path.join(output_dir, "docker")
        os.makedirs(terraform_dir, exist_ok=True)
        os.makedirs(docker_dir, exist_ok=True)

        # Generate Terraform configuration
        generate_terraform_config(all_resources, terraform_dir)
        logging.info(f"Terraform configuration generated in {terraform_dir}")

        # Generate Terraform variables
        tfvars_path = os.path.join(terraform_dir, "terraform.tfvars")
        generate_terraform_tfvars(all_resources, tfvars_path)
        logging.info(f"Terraform variables generated in {tfvars_path}")

        # Generate import script
        import_script_path = os.path.join(output_dir, "import.sh")
        generate_import_script(all_resources, import_script_path)
        logging.info(f"Terraform import script generated in {import_script_path}")

        # Generate docker-compose files
        for resource in all_resources:
            if "docker_containers" in resource and resource["docker_containers"]:
                filename = f'{resource["name"]}_docker-compose.yml'
                compose_path = os.path.join(docker_dir, filename)
                generate_docker_compose(resource["docker_containers"], compose_path)
                logging.info(f"Docker Compose file generated in {compose_path}")

    except ProxmoxerAuthenticationError as e:
        raise ProxmoxAuthenticationError(f"Authentication error with Proxmox API: {e}")
    except ConnectionError as e:
        raise ProxmoxConnectionError(f"Connection error with Proxmox API: {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Homelab Importer")
    parser.add_argument(
        "--output-dir",
        type=str,
        default=".",
        help="The directory to output the generated files to.",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Enable verbose logging.",
    )
    args = parser.parse_args()

    log_level = logging.INFO
    if args.verbose:
        log_level = logging.DEBUG
    logging.basicConfig(level=log_level, format="%(levelname)s: %(message)s")

    try:
        main(args.output_dir)
    except HomelabImporterError as e:
        logging.error(e)
        exit(1)
    except Exception as e:
        logging.error(f"An unexpected error occurred: {e}")
        exit(1)
