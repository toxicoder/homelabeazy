"""Discovery logic for Proxmox resources."""

from proxmoxer import ProxmoxAPI

def get_vms(proxmox: ProxmoxAPI):
    """Returns a list of all VMs."""
    return proxmox.cluster.resources.get(type='vm')

def get_lxc_containers(proxmox: ProxmoxAPI):
    """Returns a list of all LXC containers."""
    return proxmox.cluster.resources.get(type='lxc')

def get_storage_pools(proxmox: ProxmoxAPI):
    """Returns a list of all storage pools."""
    return proxmox.storage.get()

def get_network_bridges(proxmox: ProxmoxAPI):
    """Returns a list of all network bridges."""
    return proxmox.cluster.resources.get(type='sdn')
