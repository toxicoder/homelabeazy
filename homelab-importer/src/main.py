import os
from dotenv import load_dotenv
from proxmoxer import ProxmoxAPI
from discover import get_vms, get_lxc_containers, get_storage_pools, get_network_bridges

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
        print("VMs:", vms)

        lxc_containers = get_lxc_containers(proxmox)
        print("LXC Containers:", lxc_containers)

        storage_pools = get_storage_pools(proxmox)
        print("Storage Pools:", storage_pools)

        network_bridges = get_network_bridges(proxmox)
        print("Network Bridges:", network_bridges)

    except Exception as e:
        print(f"Error connecting to Proxmox: {e}")

if __name__ == "__main__":
    main()
