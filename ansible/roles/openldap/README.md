# Ansible Role: openldap

This role installs and configures OpenLDAP.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
service_password: "{{ vault_openldap_root_password }}"
service_admin_password: "{{ vault_openldap_admin_password }}"
```

These variables are used to set the root and admin passwords for the OpenLDAP service. They are expected to be defined in Ansible Vault.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - openldap
```

## License

MIT
