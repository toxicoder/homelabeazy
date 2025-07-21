# Proxmox Host Role

This role automates the initial configuration of a Proxmox VE server.

The role is designed to be idempotent, meaning it can be run multiple times without causing any unintended side effects. It is also designed to be modular, so you can easily customize the Proxmox host to fit your needs.

## Requirements

- Ansible 2.9 or higher
- `community.general` collection

## Role Variables

The role variables are defined in `defaults/main.yml`.

### Network Configuration

The `proxmox_host_network_interfaces` variable is a list of network interfaces to configure. Each interface is a dictionary with the following keys:

- `name`: The name of the bridge (e.g., `vmbr0`).
- `ipv4`: The IPv4 address and subnet (e.g., `192.168.1.10/24`).
- `gateway`: The IPv4 gateway.
- `vlan_aware`: Whether the bridge is VLAN aware.
- `vlan_id`: The VLAN ID for the bridge.
- `comment`: A comment for the interface.

### Storage Configuration

The `proxmox_host_storage` variable is a list of storage pools to configure. Each storage pool is a dictionary with the following keys:

- `name`: The name of the storage pool.
- `type`: The type of storage (`lvm`, `nfs`, `smb`).
- `vgname`: The volume group name for LVM storage.
- `server`: The server address for NFS/SMB storage.
- `path`: The path for NFS storage.
- `share`: The share name for SMB storage.
- `username`: The username for SMB storage.
- `password`: The password for SMB storage.
- `options`: The options for NFS storage.

### VM/LXC Templates

The `proxmox_host_templates` variable is a list of VM/LXC templates to upload. Each template is a dictionary with the following keys:

- `name`: The name of the template.
- `url`: The URL of the template image.
- `storage`: The storage pool to upload the template to.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: proxmox
  roles:
    - proxmox_host
```

## License

MIT

## Author Information

This role was created by an AI assistant.
