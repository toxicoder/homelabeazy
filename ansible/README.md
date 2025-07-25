# Ansible Setup

This directory contains the Ansible setup for managing the infrastructure.

## Directory Structure

- `group_vars/`: Contains variables that apply to all hosts.
- `inventory/`: Contains the inventory of hosts.
- `playbooks/`: Contains the playbooks for configuring the infrastructure.
- `roles/`: Contains the roles for configuring specific services.

## Roles

The following roles are available:

- `authelia`: Deploys and configures Authelia.
- `efk_stack`: Deploys and configures an EFK (Elasticsearch, Fluentd, Kibana) stack.
- `homepage`: Deploys and configures a homepage application.
- `k3s_cluster`: Deploys a high-availability k3s cluster onto VMs within Proxmox.
- `openldap`: Deploys and configures OpenLDAP.
- `pfsense`: Configures pfSense.
- `proxmox_host`: Configures a Proxmox VE server.
- `redis`: Deploys and configures Redis.
- `secure_gen`: Generates secure passwords and other secrets.
- `synology`: Manages a Synology NAS.
- `traefik`: Deploys and configures Traefik.
- `vault`: Deploys and configures HashiCorp Vault.
- `vault-secrets-operator`: Deploys and configures the Vault Secrets Operator.
- `vault_secrets`: Manages secrets in HashiCorp Vault.
- `velero`: Deploys and configures Velero.

### k3s_cluster Role

This role automates the deployment of a high-availability k3s cluster onto VMs within Proxmox. This role will first create the necessary VMs from a template and then install and configure k3s on them.

The role is designed to be idempotent, meaning it can be run multiple times without causing any unintended side effects. It is also designed to be modular, so you can easily customize the k3s cluster to fit your needs.

#### Requirements

- Ansible 2.9+
- Proxmox VE
- An Ubuntu Cloud-Init template on Proxmox

#### Role Variables

The variables that can be passed to this role and a brief description about them are as follows:

| Variable | Default | Description |
|---|---|---|
| `proxmox_host` | `pve` | The Proxmox host name. |
| `proxmox_node` | `pve` | The Proxmox node name. |
| `proxmox_user` | `root@pam` | The Proxmox user. |
| `proxmox_password` | `{{ vault_proxmox_password }}` | The Proxmox password. |
| `k3s_master_count` | `1` | The number of master nodes to create. |
| `k3s_worker_count` | `2` | The number of worker nodes to create. |
| `k3s_vm_template` | `ubuntu-2204-cloud-init` | The name of the VM template to use. |
| `k3s_vm_cores` | `2` | The number of cores for each VM. |
| `k3s_vm_memory` | `4096` | The amount of memory for each VM. |
| `k3s_vm_disk` | `local-lvm:20` | The disk size for each VM. |
| `k3s_vm_bridge` | `vmbr0` | The network bridge for each VM. |
| `k3s_vm_vlan` | `10` | The VLAN for each VM. |
| `k3s_ssh_user` | `ansible` | The SSH user for the VMs. |
| `k3s_ssh_private_key_file` | `~/.ssh/id_rsa` | The private SSH key file for the VMs. |
| `k3s_ssh_public_key_file` | `~/.ssh/id_rsa.pub` | The public SSH key file for the VMs. |
| `k3s_version` | `v1.28.4+k3s1` | The k3s version to install. |
| `k3s_cluster_name` | `k3s-cluster` | The name of the k3s cluster. |
| `k3s_cluster_domain` | `k3s.local` | The domain for the k3s cluster. |
| `k3s_cluster_cidr` | `10.42.0.0/16` | The pod network CIDR. |
| `k3s_service_cidr` | `10.43.0.0/16` | The service network CIDR. |
| `k3s_cluster_dns` | `10.43.0.10` | The cluster DNS IP. |

#### Example Playbook

```yaml
- hosts: localhost
  roles:
    - role: k3s_cluster
      proxmox_password: "your_proxmox_password"
```

### Proxmox Host Role

This role automates the initial configuration of a Proxmox VE server.

The role is designed to be idempotent, meaning it can be run multiple times without causing any unintended side effects. It is also designed to be modular, so you can easily customize the Proxmox host to fit your needs.

#### Requirements

- Ansible 2.9 or higher
- `community.general` collection

#### Role Variables

The role variables are defined in `defaults/main.yml`.

##### Network Configuration

The `proxmox_host_network_interfaces` variable is a list of network interfaces to configure. Each interface is a dictionary with the following keys:

- `name`: The name of the bridge (e.g., `vmbr0`).
- `ipv4`: The IPv4 address and subnet (e.g., `192.168.1.10/24`).
- `gateway`: The IPv4 gateway.
- `vlan_aware`: Whether the bridge is VLAN aware.
- `vlan_id`: The VLAN ID for the bridge.
- `comment`: A comment for the interface.

##### Storage Configuration

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

##### VM/LXC Templates

The `proxmox_host_templates` variable is a list of VM/LXC templates to upload. Each template is a dictionary with the following keys:

- `name`: The name of the template.
- `url`: The URL of the template image.
- `storage`: The storage pool to upload the template to.

#### Example Playbook

```yaml
- hosts: proxmox
  roles:
    - proxmox_host
```

### Synology Role

This Ansible module allows you to manage a Synology NAS.

#### Requirements

- Python >= 3.6
- `requests` library

#### Usage

To use this module, you need to add it to your Ansible playbook. Here is an example of how to use the module to create a user, group, and shared folder:

```yaml
- name: Manage Synology NAS
  hosts: localhost
  gather_facts: false
  vars:
    synology_nas_ip: "192.168.1.100"
    synology_nas_username: "admin"
    synology_nas_password: "password"
    test_user: "testuser"
    test_group: "testgroup"
    test_folder: "testfolder"

  tasks:
    - name: Create test user
      synology:
        host: "{{ synology_nas_ip }}"
        username: "{{ synology_nas_username }}"
        password: "{{ synology_nas_password }}"
        resource: user
        name: "{{ test_user }}"
        state: present
        config:
          password: "password"
          email: "testuser@example.com"

    - name: Create test group
      synology:
        host: "{{ synology_nas_ip }}"
        username: "{{ synology_nas_username }}"
        password: "{{ synology_nas_password }}"
        resource: group
        name: "{{ test_group }}"
        state: present
        config:
          description: "Test group"

    - name: Create test shared folder
      synology:
        host: "{{ synology_nas_ip }}"
        username: "{{ synology_nas_username }}"
        password: "{{ synology_nas_password }}"
        resource: shared_folder
        name: "{{ test_folder }}"
        state: present
        config:
          permissions:
            - name: "{{ test_user }}"
              type: "user"
              permission: "rw"
            - name: "{{ test_group }}"
              type: "group"
              permission: "ro"

    - name: Create backup task
      synology:
        host: "{{ synology_nas_ip }}"
        username: "{{ synology_nas_username }}"
        password: "{{ synology_nas_password }}"
        resource: backup_task
        name: "My Backup Task"
        state: present
        config:
          source: "/volume1/data"
          destination: "/volume1/backup"
```

#### Parameters

- `host`: The IP address or hostname of the Synology NAS. (required)
- `port`: The port number for the Synology API. (default: 5001)
- `username`: The username for the Synology NAS. (required)
- `password`: The password for the Synology NAS. (required)
- `state`: The desired state of the resource. Can be `present` or `absent`. (default: `present`)
- `resource`: The type of resource to manage. Can be `shared_folder`, `user`, `group`, or `backup_task`. (required)
- `name`: The name of the resource. (required)
- `config`: A dictionary of configuration options for the resource. (optional)

##### `shared_folder` config

- `permissions`: A list of permissions to set on the shared folder. Each permission is a dictionary with the following keys:
  - `name`: The name of the user or group.
  - `type`: The type of the principal. Can be `user` or `group`.
  - `permission`: The permission to set. Can be `ro` (read-only) or `rw` (read-write).

##### `user` config

- `password`: The password for the user.
- `email`: The email address for the user.

##### `group` config

- `description`: The description for the group.

##### `backup_task` config

- `source`: The source directory for the backup task.
- `destination`: The destination directory for the backup task.
- `schedule`: The schedule for the backup task.
- `retention`: The retention policy for the backup task.

## Playbooks

The following playbooks are available:

- `setup.yml`: Sets up the entire infrastructure.
- `test.yml`: Runs tests against the infrastructure.
- `secure-gen.yml`: Generates secure passwords and other secrets.
- `mock_synology_api.py`: A mock Synology API for testing.
- `test_synology_mock.yml`: Tests the Synology mock API.
