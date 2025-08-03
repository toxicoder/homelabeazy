# Ansible Role: secure-gen

This role installs the secure-gen tool.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
python_venv_path: /opt/secure-gen
```

The path to the python virtual environment where the tool will be installed.

## Dependencies

- `python-base`

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - secure-gen
```

## License

MIT
