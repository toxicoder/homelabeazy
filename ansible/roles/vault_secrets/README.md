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

It is highly recommended to use a tool like `pwgen` to generate random passwords for your secrets. For example:

```bash
pwgen -s 64 1
```

You can then use the generated password in your `values.yaml` file.

It is also recommended to encrypt your `values.yaml` files using Ansible Vault to keep your secrets safe. For example:

```bash
ansible-vault encrypt config/apps/openldap/values.yaml
```

This will encrypt the `values.yaml` file and prevent anyone from reading the secrets without the vault password.

When you run the `ansible-playbook` command, you will need to provide the vault password to decrypt the `values.yaml` files. For example:

```bash
ansible-playbook --ask-vault-pass playbooks/main.yml
```

This will prompt you for the vault password and then use it to decrypt the `values.yaml` files.

By following these recommendations, you can ensure that your secrets are stored securely and that they are not accidentally exposed.
