# Synology Ansible Module

This Ansible module allows you to manage a Synology NAS.

## Requirements

- Python >= 3.6
- `requests` library

## Usage

To use this module, you need to add it to your Ansible playbook. Here is an example of how to use the module to create a user, group, and shared folder:

```yaml
- name: Manage Synology NAS
  hosts: localhost
  gather_facts: false
  vars:
    synology_nas_ip: "192.168.1.100"
    synology_nas_username: "admin"
    synology_nas_password: "password"
    test_user: "testuser"
    test_group: "testgroup"
    test_folder: "testfolder"

  tasks:
    - name: Create test user
      synology:
        host: "{{ synology_nas_ip }}"
        username: "{{ synology_nas_username }}"
        password: "{{ synology_nas_password }}"
        resource: user
        name: "{{ test_user }}"
        state: present
        config:
          password: "password"
          email: "testuser@example.com"

    - name: Create test group
      synology:
        host: "{{ synology_nas_ip }}"
        username: "{{ synology_nas_username }}"
        password: "{{ synology_nas_password }}"
        resource: group
        name: "{{ test_group }}"
        state: present
        config:
          description: "Test group"

    - name: Create test shared folder
      synology:
        host: "{{ synology_nas_ip }}"
        username: "{{ synology_nas_username }}"
        password: "{{ synology_nas_password }}"
        resource: shared_folder
        name: "{{ test_folder }}"
        state: present
        config:
          permissions:
            - name: "{{ test_user }}"
              type: "user"
              permission: "rw"
            - name: "{{ test_group }}"
              type: "group"
              permission: "ro"

    - name: Create backup task
      synology:
        host: "{{ synology_nas_ip }}"
        username: "{{ synology_nas_username }}"
        password: "{{ synology_nas_password }}"
        resource: backup_task
        name: "My Backup Task"
        state: present
        config:
          source: "/volume1/data"
          destination: "/volume1/backup"
```

## Parameters

- `host`: The IP address or hostname of the Synology NAS. (required)
- `port`: The port number for the Synology API. (default: 5001)
- `username`: The username for the Synology NAS. (required)
- `password`: The password for the Synology NAS. (required)
- `state`: The desired state of the resource. Can be `present` or `absent`. (default: `present`)
- `resource`: The type of resource to manage. Can be `shared_folder`, `user`, `group`, or `backup_task`. (required)
- `name`: The name of the resource. (required)
- `config`: A dictionary of configuration options for the resource. (optional)

### `shared_folder` config

- `permissions`: A list of permissions to set on the shared folder. Each permission is a dictionary with the following keys:
  - `name`: The name of the user or group.
  - `type`: The type of the principal. Can be `user` or `group`.
  - `permission`: The permission to set. Can be `ro` (read-only) or `rw` (read-write).

### `user` config

- `password`: The password for the user.
- `email`: The email address for the user.

### `group` config

- `description`: The description for the group.

### `backup_task` config

- `source`: The source directory for the backup task.
- `destination`: The destination directory for the backup task.
- `schedule`: The schedule for the backup task.
- `retention`: The retention policy for the backup task.
