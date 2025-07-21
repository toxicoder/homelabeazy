#!/usr/bin/python

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

from ansible.module_utils.basic import AnsibleModule

try:
    import requests
except ImportError:
    HAS_REQUESTS = False
else:
    HAS_REQUESTS = True

class SynologyClient:
    def __init__(self, host, port, username, password):
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.sid = None
        self.session = requests.Session()

    def login(self):
        url = f'https://{self.host}:{self.port}/webapi/auth.cgi'
        params = {
            'api': 'SYNO.API.Auth',
            'version': '2',
            'method': 'login',
            'account': self.username,
            'passwd': self.password,
            'session': 'Ansible',
            'format': 'sid'
        }
        response = self.session.get(url, params=params, verify=False)
        response.raise_for_status()
        self.sid = response.json()['data']['sid']

    def request(self, api, method, params=None):
        if not self.sid:
            self.login()

        url = f'https://{self.host}:{self.port}/webapi/entry.cgi'
        base_params = {
            'api': api,
            'version': '2',
            'method': method,
            '_sid': self.sid
        }
        if params:
            base_params.update(params)

        response = self.session.get(url, params=base_params, verify=False)
        response.raise_for_status()
        return response.json()

def manage_shared_folder(client, name, state, config):
    current_state = _get_current_shared_folder_state(client, name)
    desired_state = {'name': name, 'state': state, **config}

    if state == 'present':
        if current_state:
            # Folder exists, check for changes
            diff = _compare_states(current_state, desired_state)
            if diff:
                # Apply changes
                return {'changed': True, 'diff': diff}
            return {'changed': False}
        else:
            # Folder does not exist, create it
            create_params = {
                'folder_path': f'/homes/{name}',
                'name': name,
                'force_parent': 'true',
            }
            client.request('SYNO.FileStation.CreateFolder', 'create', params=create_params)
            if 'permissions' in config:
                manage_permissions(client, name, config['permissions'])
            return {'changed': True}
    elif state == 'absent':
        if current_state:
            # Folder exists, delete it
            delete_params = {
                'path': f'/homes/{name}',
            }
            client.request('SYNO.FileStation.Delete', 'start', params=delete_params)
            return {'changed': True}
        else:
            # Folder does not exist
            return {'changed': False}

def _get_current_shared_folder_state(client, name):
    data = client.request('SYNO.FileStation.List', 'get_info')
    folders = data['data']['shares']
    folder = next((f for f in folders if f['name'] == name), None)
    if not folder:
        return None

    acl_data = client.request('SYNO.FileStation.GetACL', 'get', params={'path': folder['path']})
    permissions = []
    for acl in acl_data['data']['acl']:
        permissions.append({
            'name': acl['principal'],
            'type': acl['type'],
            'permission': acl['permission']
        })

    return {
        'name': folder['name'],
        'state': 'present',
        'permissions': permissions
    }

def _compare_states(current_state, desired_state):
    diff = {}
    for key, value in desired_state.items():
        if key not in current_state or current_state[key] != value:
            diff[key] = {
                'current': current_state.get(key),
                'desired': value
            }
    return diff

def manage_user(client, name, state, config):
    current_state = _get_current_user_state(client, name)
    desired_state = {'name': name, 'state': state, **config}

    if state == 'present':
        if current_state:
            # User exists, check for changes
            diff = _compare_states(current_state, desired_state)
            if diff:
                # Apply changes
                return {'changed': True, 'diff': diff}
            return {'changed': False}
        else:
            # User does not exist, create it
            create_params = {
                'name': name,
                'password': config.get('password'),
                'email': config.get('email')
            }
            client.request('SYNO.Core.User', 'create', params=create_params)
            return {'changed': True}
    elif state == 'absent':
        if current_state:
            # User exists, delete it
            delete_params = {
                'name': name,
            }
            client.request('SYNO.Core.User', 'delete', params=delete_params)
            return {'changed': True}
        else:
            # User does not exist
            return {'changed': False}

def _get_current_user_state(client, name):
    data = client.request('SYNO.Core.User', 'list')
    users = data['data']['users']
    user = next((u for u in users if u['name'] == name), None)
    if not user:
        return None

    return {
        'name': user['name'],
        'state': 'present',
        'email': user.get('email')
    }

def manage_group(client, name, state, config):
    current_state = _get_current_group_state(client, name)
    desired_state = {'name': name, 'state': state, **config}

    if state == 'present':
        if current_state:
            # Group exists, check for changes
            diff = _compare_states(current_state, desired_state)
            if diff:
                # Apply changes
                return {'changed': True, 'diff': diff}
            return {'changed': False}
        else:
            # Group does not exist, create it
            create_params = {
                'name': name,
                'description': config.get('description')
            }
            client.request('SYNO.Core.Group', 'create', params=create_params)
            return {'changed': True}
    elif state == 'absent':
        if current_state:
            # Group exists, delete it
            delete_params = {
                'name': name,
            }
            client.request('SYNO.Core.Group', 'delete', params=delete_params)
            return {'changed': True}
        else:
            # Group does not exist
            return {'changed': False}

def _get_current_group_state(client, name):
    data = client.request('SYNO.Core.Group', 'list')
    groups = data['data']['groups']
    group = next((g for g in groups if g['name'] == name), None)
    if not group:
        return None

    return {
        'name': group['name'],
        'state': 'present',
        'description': group.get('description')
    }

def _get_current_backup_task_state(client, name):
    data = client.request('SYNO.Backup.Task', 'list')
    tasks = data['data']['tasks']
    task = next((t for t in tasks if t['name'] == name), None)
    if not task:
        return None

    return {
        'name': task['name'],
        'state': 'present',
    }

def manage_backup_task(client, name, state, config):
    current_state = _get_current_backup_task_state(client, name)
    desired_state = {'name': name, 'state': state, **config}

    if state == 'present':
        if current_state:
            # Task exists, check for changes
            diff = _compare_states(current_state, desired_state)
            if diff:
                # Apply changes
                return {'changed': True, 'diff': diff}
            return {'changed': False}
        else:
            # Task does not exist, create it
            create_params = {
                'name': name,
                **config
            }
            client.request('SYNO.Backup.Task', 'create', params=create_params)
            return {'changed': True}
    elif state == 'absent':
        if current_state:
            # Task exists, delete it
            delete_params = {
                'name': name,
            }
            client.request('SYNO.Backup.Task', 'delete', params=delete_params)
            return {'changed': True}
        else:
            # Task does not exist
            return {'changed': False}

def manage_permissions(client, folder_name, permissions):
    for perm in permissions:
        principal_type = perm['type']
        principal_name = perm['name']
        permission = perm['permission']

        acl = {
            'path': f'/homes/{folder_name}',
            'action': 'set',
            'principal': f'{principal_name}',
            'type': principal_type,
            'permission': permission
        }
        client.request('SYNO.FileStation.SetACL', 'set', params=acl)

def main():
    module = AnsibleModule(
        argument_spec=dict(
            host=dict(type='str', required=True),
            port=dict(type='int', default=5001),
            username=dict(type='str', required=True),
            password=dict(type='str', required=True, no_log=True),
            state=dict(type='str', default='present', choices=['present', 'absent']),
            resource=dict(type='str', required=True, choices=['shared_folder', 'user', 'group']),
            name=dict(type='str', required=True),
            config=dict(type='dict', default={})
        ),
        supports_check_mode=True
    )

    if not HAS_REQUESTS:
        module.fail_json(msg='requests library is required for this module')

    client = SynologyClient(module.params['host'], module.params['port'], module.params['username'], module.params['password'])

    if module.params['resource'] == 'shared_folder':
        result = manage_shared_folder(client, module.params['name'], module.params['state'], module.params['config'])
        module.exit_json(**result)
    elif module.params['resource'] == 'user':
        result = manage_user(client, module.params['name'], module.params['state'], module.params['config'])
        module.exit_json(**result)
    elif module.params['resource'] == 'group':
        result = manage_group(client, module.params['name'], module.params['state'], module.params['config'])
        module.exit_json(**result)
    elif module.params['resource'] == 'backup_task':
        result = manage_backup_task(client, module.params['name'], module.params['state'], module.params['config'])
        module.exit_json(**result)

    module.exit_json(changed=False)

if __name__ == '__main__':
    main()
