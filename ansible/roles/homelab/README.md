# Ansible Role: homelab

This role is a meta-role that deploys the core infrastructure for the homelab.

## Role Variables

This role does not have any variables.

## Dependencies

This role depends on the following roles:
- `traefik`
- `efk-stack`

## Example Playbook

```yaml
- hosts: k3s_masters
  roles:
    - homelab
```

## License

MIT
