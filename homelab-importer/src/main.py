import os
import argparse
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


def main(output_dir: str) -> None:
    """Connects to Proxmox and generates Terraform configuration."""
    load_dotenv()

    proxmox_host = os.getenv("PROXMOX_HOST")
    proxmox_user = os.getenv("PROXMOX_USER")
    proxmox_password = os.getenv("PROXMOX_PASSWORD")

    if not all([proxmox_host, proxmox_user, proxmox_password]):
        print(
            "Error: PROXMOX_HOST, PROXMOX_USER, "
            "and PROXMOX_PASSWORD must be set."
        )
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
            map_lxc_to_terraform(c) for c in lxc_containers
        ]

        all_resources = terraform_vms + terraform_lxc_containers

        # Generate Terraform configuration
        tf_config_path = os.path.join(output_dir, "homelab.tf")
        generate_terraform_config(all_resources, tf_config_path)
        print(f"Terraform configuration generated in {tf_config_path}")

        # Generate Terraform variables
        tfvars_path = os.path.join(output_dir, "terraform.tfvars")
        generate_terraform_tfvars(all_resources, tfvars_path)
        print(f"Terraform variables generated in {tfvars_path}")

        # Generate import script
        import_script_path = os.path.join(output_dir, "import.sh")
        generate_import_script(all_resources, import_script_path)
        print(f"Terraform import script generated in {import_script_path}")

        # Generate docker-compose files
        for resource in all_resources:
            if "docker_containers" in resource and resource["docker_containers"]:
                filename = f'{resource["name"]}_docker-compose.yml'
                compose_path = os.path.join(output_dir, filename)
                generate_docker_compose(
                    resource["docker_containers"], compose_path
                )
                print(f"Docker Compose file generated in {compose_path}")

    except Exception as e:
        print(f"An error occurred: {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Homelab Importer")
    parser.add_argument(
        "--output-dir",
        type=str,
        default=".",
        help="The directory to output the generated files to.",
    )
    args = parser.parse_args()
    main(args.output_dir)
