# Ansible Role: secure_gen

This role installs the secure_gen tool.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
python_venv_path: /opt/secure_gen
```

The path to the python virtual environment where the tool will be installed.

## Dependencies

- `python_base`

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - secure_gen
```

## License

MIT
