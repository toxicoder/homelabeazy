# Ansible Role: velero

This role installs and configures Velero.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
velero_version: "1.9.0"
velero_install_dir: "/opt/velero"

# The following variables should be set in a secure way, e.g. using Ansible Vault
velero_minio_vault_path: "secret/data/minio"
velero_minio_vault_access_key_name: "access_key"
velero_minio_vault_secret_key_name: "secret_key"
```

## Dependencies

- `minio`

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - velero
```

## License

MIT
