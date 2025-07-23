# Synology NAS Ansible Collection

This collection provides Ansible modules for managing Synology NAS devices.

## Installation

To install this collection, use the following command:

```
ansible-galaxy collection install synology.nas
```

## Usage

Here's an example of how to use the `synology` module to create a shared folder:

```yaml
- name: Create a shared folder
  synology.nas.synology:
    host: your_nas_ip
    username: your_username
    password: your_password
    resource: shared_folder
    name: my_shared_folder
    state: present
```
