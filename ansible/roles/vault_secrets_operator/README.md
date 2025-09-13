# Ansible Role: vault-secrets-operator

This role deploys the Vault Secrets Operator.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
vault_secrets_operator_namespace: vault-secrets-operator
vault_secrets_operator_chart_version: "0.1.0"
vault_secrets_operator_helm_values: {}
```

## Dependencies

- `vault`

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - vault-secrets-operator
```

## License

MIT
