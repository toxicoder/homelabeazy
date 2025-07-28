#!/usr/bin/env python

import json
import os
from python_terraform import Terraform

def get_inventory():
    inventory = {
        "_meta": {
            "hostvars": {}
        }
    }

    # Path to the terraform state file
    tf_state_path = os.path.join(os.path.dirname(__file__), '..', '..', '..', 'infrastructure', 'stealth-vm')

    # Initialize python-terraform
    tf = Terraform(working_dir=tf_state_path)
    outputs = tf.output(json=True)

    if not outputs:
        raise Exception(f"Error running terraform output")

    if "stealth_vm_ip" in outputs and outputs["stealth_vm_ip"]["value"]:
        inventory.setdefault("stealth_vm", {"hosts": []})["hosts"].append("stealth-vm-1")
        inventory["_meta"]["hostvars"]["stealth-vm-1"] = {
            "ansible_host": outputs["stealth_vm_ip"]["value"]
        }

    return inventory

if __name__ == "__main__":
    print(json.dumps(get_inventory(), indent=4))
