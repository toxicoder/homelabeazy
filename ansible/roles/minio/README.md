# MinIO Ansible Role

This role deploys MinIO, a high-performance, S3-compatible object storage server.

The role is designed to be idempotent, meaning it can be run multiple times without causing any unintended side effects. It is also designed to be modular, so you can easily customize the MinIO installation to fit your needs.

## Requirements

- Ansible 2.9 or higher
- A Debian/Ubuntu or RedHat/CentOS based system
- The `community.hashi_vault` collection must be installed.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

| Variable                      | Default Value                    | Description                                       |
| ----------------------------- | -------------------------------- | ------------------------------------------------- |
| `minio_version`               | `RELEASE.2023-01-25T00-19-53Z`   | The version of MinIO to install.                  |
| `minio_data_dir`              | `/data`                          | The directory to store MinIO data in.             |
| `minio_vault_path`            | `secret/data/minio`              | The path to the MinIO credentials in Vault.       |
| `minio_vault_access_key_name` | `access_key`                     | The name of the access key in the Vault secret.   |
| `minio_vault_secret_key_name` | `secret_key`                     | The name of the secret key in the Vault secret.   |

The role fetches the MinIO access key and secret key from HashiCorp Vault. You need to have a Vault server running and the necessary environment variables (`VAULT_ADDR`, `VAULT_TOKEN`) configured for the Ansible user.

The secrets in Vault should be stored in a KVv2 engine at the path specified by `minio_vault_path`. The secret should have two keys: one for the access key and one for the secret key, with the names specified by `minio_vault_access_key_name` and `minio_vault_secret_key_name`.

## Dependencies

This role has no Ansible role dependencies. However, it requires the `community.hashi_vault` collection to be installed, as listed in the requirements.

## Example Playbook

```yaml
- hosts: servers
  roles:
    - role: minio
      vars:
        minio_vault_path: "secret/data/production/minio"
```

## License

MIT

## Author Information

This role was created by an AI assistant.
