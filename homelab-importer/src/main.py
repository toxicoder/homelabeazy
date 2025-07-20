import os
from dotenv import load_dotenv
from proxmoxer import ProxmoxAPI
from discover import get_vms, get_lxc_containers, get_docker_containers
from mapping import map_vm_to_terraform, map_lxc_to_terraform
from terraform import generate_terraform_config


def main():
    """Connects to Proxmox and prints a list of nodes."""
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
            verify_ssl=False,
        )
        print("Successfully connected to Proxmox!")

        vms = get_vms(proxmox)
        lxc_containers = get_lxc_containers(proxmox)

        for vm in vms:
            vm["docker_containers"] = get_docker_containers(
                proxmox, vm["node"], vm["vmid"], "qemu"
            )
        for container in lxc_containers:
            container["docker_containers"] = get_docker_containers(
                proxmox, container["node"], container["vmid"], "lxc"
            )

        terraform_vms = [map_vm_to_terraform(vm) for vm in vms]
        terraform_lxc_containers = [
            map_lxc_to_terraform(container) for container in lxc_containers
        ]

        all_resources = terraform_vms + terraform_lxc_containers
        generate_terraform_config(all_resources, "homelab.tf")
        print("Terraform configuration generated in homelab.tf")

    except Exception as e:
        print(f"Error connecting to Proxmox: {e}")


if __name__ == "__main__":
    main()
