# Ansible Role: vault

This role installs and configures Vault.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
vault_hostname: "vault.{{ domain_root }}"
```

The hostname for the Vault service. The `domain_root` variable is expected to be defined in your inventory.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - vault
```

## License

MIT
