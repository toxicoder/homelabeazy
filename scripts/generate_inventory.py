import json
import yaml
import sys

def main():
    """
    Generates an Ansible inventory file from Terraform output.
    """
    try:
        terraform_output = json.load(sys.stdin)
    except json.JSONDecodeError:
        print("Error: Invalid JSON input from stdin.", file=sys.stderr)
        sys.exit(1)

    inventory = {
        'all': {
            'hosts': {}
        }
    }

    # Add master node
    master_name = terraform_output.get('k3s_master_name', {}).get('value')
    master_ip = terraform_output.get('k3s_master_ip', {}).get('value')
    if master_name and master_ip:
        inventory['all']['hosts'][master_name] = {'ansible_host': master_ip}

    # Add worker nodes
    worker_names = terraform_output.get('k3s_worker_names', {}).get('value', [])
    worker_ips = terraform_output.get('k3s_worker_ips', {}).get('value', [])

    for name, ip in zip(worker_names, worker_ips):
        inventory['all']['hosts'][name] = {'ansible_host': ip}

    with open('ansible/inventory/inventory.auto.yml', 'w') as f:
        yaml.dump(inventory, f, default_flow_style=False)

    print("Successfully generated ansible/inventory/inventory.auto.yml")

if __name__ == "__main__":
    main()
