# Vault Secrets

This role creates secrets in Vault from values files.

## Usage

To create secrets in Vault, you need to create a `values.yaml` file in the `config/apps/<app_name>` directory. This file should contain the following:

```yaml
vault_path: "<path_in_vault>"
secrets:
  <secret_name>: "<secret_value>"
```

The `vault_path` is the path where the secrets will be stored in Vault. The `secrets` are a dictionary of key-value pairs that will be created as secrets in Vault.

For example, to create the OpenLDAP secrets, you would create a `config/apps/openldap/values.yaml` file with the following content:

```yaml
vault_path: "openldap"
secrets:
  root-password: "changeme"
  admin-password: "changeme"
```

This will create the `root-password` and `admin-password` secrets in Vault at the `secrets/data/openldap` path.
