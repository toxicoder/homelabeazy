#!/usr/bin/env python

import json
import os
import sys
from python_terraform import Terraform, TerraformCommandError

def get_inventory():
    """
    Generates Ansible dynamic inventory from Terraform state.

    Reads the Terraform state from the path specified by the
    TERRAFORM_STATE_PATH environment variable. If the variable is not set,
    it defaults to '../../infrastructure/stealth-vm'.
    """
    inventory = {
        "_meta": {
            "hostvars": {}
        }
    }

    # Path to the terraform state file
    default_path = os.path.join(os.path.dirname(__file__), '..', '..', '..', 'infrastructure', 'stealth-vm')
    tf_state_path = os.environ.get("TERRAFORM_STATE_PATH", default_path)

    if not os.path.isdir(tf_state_path):
        print(f"Error: Terraform state path '{tf_state_path}' does not exist or is not a directory.", file=sys.stderr)
        sys.exit(1)

    try:
        # Initialize python-terraform
        tf = Terraform(working_dir=tf_state_path)
        outputs = tf.output(json=True)

    except TerraformCommandError as e:
        print(f"Error running terraform output: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred: {e}", file=sys.stderr)
        sys.exit(1)


    if not outputs:
        return inventory

    if "stealth_vm_ip" in outputs and "value" in outputs["stealth_vm_ip"] and outputs["stealth_vm_ip"]["value"]:
        inventory.setdefault("stealth_vm", {"hosts": []})["hosts"].append("stealth-vm-1")
        inventory["_meta"]["hostvars"]["stealth-vm-1"] = {
            "ansible_host": outputs["stealth_vm_ip"]["value"]
        }

    return inventory

if __name__ == "__main__":
    print(json.dumps(get_inventory(), indent=4))
