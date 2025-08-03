# Ansible Role: consul

This role installs and configures Consul.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
consul_version: "1.18.1"
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - consul
```

## License

MIT
