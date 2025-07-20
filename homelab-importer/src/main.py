import os
from dotenv import load_dotenv
from proxmoxer import ProxmoxAPI

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
        nodes = proxmox.nodes.get()
        print("Successfully connected to Proxmox!")
        print("Nodes:", [node["node"] for node in nodes])
    except Exception as e:
        print(f"Error connecting to Proxmox: {e}")

if __name__ == "__main__":
    main()
