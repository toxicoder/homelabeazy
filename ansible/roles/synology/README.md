# Ansible Role: synology

This role manages a Synology NAS.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
synology_nas_ip: ""
synology_nas_username: ""
synology_nas_password: ""
```

These variables are used to connect to the Synology NAS.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - synology
```

## License

MIT
