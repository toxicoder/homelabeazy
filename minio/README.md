# MinIO Ansible Role

This role deploys MinIO, a high-performance, S3-compatible object storage server.

## Requirements

- Ansible 2.9 or higher
- A Debian/Ubuntu or RedHat/CentOS based system

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

| Variable           | Default Value                    | Description                            |
| ------------------ | -------------------------------- | -------------------------------------- |
| `minio_version`    | `RELEASE.2023-01-25T00-19-53Z`   | The version of MinIO to install.       |
| `minio_access_key` | `minio`                          | The access key for the MinIO server.   |
| `minio_secret_key` | `minio123`                       | The secret key for the MinIO server.   |
| `minio_data_dir`   | `/data`                          | The directory to store MinIO data in.  |

## Dependencies

None.

## Example Playbook

```yaml
- hosts: servers
  roles:
    - role: minio
      vars:
        minio_access_key: "my-access-key"
        minio_secret_key: "my-super-secret-key"
```

## License

MIT

## Author Information

This role was created by an AI assistant.
