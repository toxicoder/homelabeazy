---
layout: default
title: Troubleshooting
nav_order: 11
---

# Troubleshooting

This section provides solutions to common problems you may encounter during the setup process.

## `scripts/setup.sh` Script Fails

If the `scripts/setup.sh` script fails, it is most likely due to an issue with the Terraform or Ansible commands that it is running. To debug the issue, you can run the commands manually and inspect the output.

1.  **Run Terraform manually:**
    ```bash
    cd terraform
    terraform init
    terraform plan
    terraform apply
    ```
2.  **Run Ansible manually:**
    ```bash
    cd ansible
    ansible-playbook -i inventory/inventory.auto.yml playbooks/main.yml
    ```

## Terraform Fails to Apply Changes

If Terraform fails to apply the changes, it may be due to a problem with your Proxmox environment. Check the following:

  - **Proxmox API Token:** Make sure your Proxmox API token has the correct permissions.
  - **Proxmox Host:** Make sure the Proxmox host is running and accessible.
  - **Cloud-init Template:** Make sure the cloud-init template exists and is configured correctly.

## Ansible Playbook Fails to Run

If the Ansible playbook fails to run, it may be due to a problem with your SSH connection. Check the following:

  - **SSH Key:** Make sure your SSH key is added to your SSH agent.
  - **SSH Connection:** Make sure you can connect to the nodes using SSH.

## Application Is Not Accessible

If an application is not accessible, it may be due to a problem with the Traefik Ingress controller or the application itself.

  - **Check the Traefik Dashboard:** The Traefik dashboard will show you the status of your Ingress routes and whether there are any errors.
  - **Check the Application Logs:** Use `kubectl logs` to check the logs of the application's pods. This will often give you a clue as to what is wrong.
    ```bash
    kubectl logs -l app=<app-name>
    ```
  - **Check the Ingress Route:** Make sure the Ingress route for the application is configured correctly.
    ```bash
    kubectl get ingressroute -n <namespace>
    ```
  - **Check DNS:** Make sure the DNS record for the application is pointing to the correct IP address.

## Restarting the Setup Process

If you encounter an issue that you cannot resolve, you can restart the setup process from the beginning.

1.  **Destroy the infrastructure:**

    ```bash
    make destroy
    ```

2.  **Delete the `terraform.tfvars` file:**

    ```bash
    rm infrastructure/proxmox/terraform.tfvars
    ```

3.  **Delete the `ansible/inventory/inventory.auto.yml` file:**

    ```bash
    rm ansible/inventory/inventory.auto.yml
    ```

4.  **Run the setup process again by following the steps in the "Getting Started" section.**
