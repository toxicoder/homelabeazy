# k3s_cluster Ansible Role

This role automates the deployment of a high-availability k3s cluster onto VMs within Proxmox. This role will first create the necessary VMs from a template and then install and configure k3s on them.

## Requirements

- Ansible 2.9+
- Proxmox VE
- An Ubuntu Cloud-Init template on Proxmox

## Role Variables

The variables that can be passed to this role and a brief description about them are as follows:

| Variable                      | Default                        | Description                                     |
| ----------------------------- | ------------------------------ | ----------------------------------------------- |
| `proxmox_host`                | `pve`                          | The Proxmox host name.                          |
| `proxmox_node`                | `pve`                          | The Proxmox node name.                          |
| `proxmox_user`                | `root@pam`                     | The Proxmox user.                               |
| `proxmox_password`            | `{{ vault_proxmox_password }}` | The Proxmox password.                           |
| `k3s_master_count`            | `1`                            | The number of master nodes to create.           |
| `k3s_worker_count`            | `2`                            | The number of worker nodes to create.           |
| `k3s_vm_template`             | `ubuntu-2204-cloud-init`       | The name of the VM template to use.             |
| `k3s_vm_cores`                | `2`                            | The number of cores for each VM.                |
| `k3s_vm_memory`               | `4096`                         | The amount of memory for each VM.               |
| `k3s_vm_disk`                 | `local-lvm:20`                 | The disk size for each VM.                      |
| `k3s_vm_bridge`               | `vmbr0`                        | The network bridge for each VM.                 |
| `k3s_vm_vlan`                 | `10`                           | The VLAN for each VM.                           |
| `k3s_ssh_user`                | `ansible`                      | The SSH user for the VMs.                       |
| `k3s_ssh_private_key_file`    | `~/.ssh/id_rsa`                | The private SSH key file for the VMs.           |
| `k3s_ssh_public_key_file`     | `~/.ssh/id_rsa.pub`            | The public SSH key file for the VMs.            |
| `k3s_version`                 | `v1.28.4+k3s1`                 | The k3s version to install.                     |
| `k3s_cluster_name`            | `k3s-cluster`                  | The name of the k3s cluster.                    |
| `k3s_cluster_domain`          | `k3s.local`                    | The domain for the k3s cluster.                 |
| `k3s_cluster_cidr`            | `10.42.0.0/16`                 | The pod network CIDR.                           |
| `k3s_service_cidr`            | `10.43.0.0/16`                 | The service network CIDR.                       |
| `k3s_cluster_dns`             | `10.43.0.10`                   | The cluster DNS IP.                             |

## Dependencies

None.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - role: k3s_cluster
      proxmox_password: "your_proxmox_password"
```

## License

MIT
