import os
from dotenv import load_dotenv
from proxmoxer import ProxmoxAPI
from discover import get_vms, get_lxc_containers
from mapping import map_vm_to_terraform, map_lxc_to_terraform
from terraform import (
    generate_terraform_config,
    generate_terraform_tfvars,
    generate_import_script,
)
from docker import generate_docker_compose


def main() -> None:
    """Connects to Proxmox and generates Terraform configuration."""
    load_dotenv()

    proxmox_host = os.getenv("PROXMOX_HOST")
    proxmox_user = os.getenv("PROXMOX_USER")
    proxmox_password = os.getenv("PROXMOX_PASSWORD")

    if not all([proxmox_host, proxmox_user, proxmox_password]):
        print("Error: PROXMOX_HOST, PROXMOX_USER, and PROXMOX_PASSWORD must be set.")
        return

    try:
        proxmox = ProxmoxAPI(
            proxmox_host,
            user=proxmox_user,
            password=proxmox_password,
            verify_ssl=True,
        )
        print("Successfully connected to Proxmox!")

        vms = get_vms(proxmox)
        lxc_containers = get_lxc_containers(proxmox)

        terraform_vms = [map_vm_to_terraform(vm) for vm in vms]
        terraform_lxc_containers = [
            map_lxc_to_terraform(container) for container in lxc_containers
        ]

        all_resources = terraform_vms + terraform_lxc_containers

        # Generate Terraform configuration
        generate_terraform_config(all_resources, "homelab.tf")
        print("Terraform configuration generated in homelab.tf")

        # Generate Terraform variables
        generate_terraform_tfvars(all_resources, "terraform.tfvars")
        print("Terraform variables generated in terraform.tfvars")

        # Generate import script
        generate_import_script(all_resources, "import.sh")
        print("Terraform import script generated in import.sh")

        # Generate docker-compose files
        for resource in all_resources:
            if "docker_containers" in resource and resource["docker_containers"]:
                filename = f'{resource["name"]}_docker-compose.yml'
                generate_docker_compose(resource["docker_containers"], filename)
                print(f"Docker Compose file generated in {filename}")

    except Exception as e:
        print(f"An error occurred: {e}")


if __name__ == "__main__":
    main()
