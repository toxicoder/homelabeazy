# Ansible Role: k3s-cluster

This role installs a k3s cluster.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
k3s_version: "v1.29.3+k3s1"
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - k3s-cluster
```

## License

MIT
