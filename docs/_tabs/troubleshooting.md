---
layout: default
title: Troubleshooting
parent: Guides
nav_order: 4
permalink: /troubleshooting
---

# Troubleshooting

This guide provides solutions to common problems you may encounter while using Homelabeazy. If you can't find a solution to your problem here, please feel free to [open an issue](https://github.com/homelabeazy/homelabeazy/issues) on our GitHub repository.

## Setup and Installation Issues

### `make setup-interactive` fails

If the `make setup-interactive` script fails, it is most likely due to an issue with the `homelab-importer` tool. To debug the issue, you can run the tool manually and inspect the output.

```bash
# Activate the virtual environment
source .venv/bin/activate

# Run the importer tool
homelab-importer --config-dir /path/to/your/private/config
```

### Terraform fails to apply changes

If Terraform fails to apply the changes, it may be due to a problem with your Proxmox environment. Check the following:

*   **Proxmox API Token:** Ensure that your Proxmox API token has the correct permissions. It should have the `Datastore.AllocateSpace`, `Datastore.Audit`, `Sys.Audit`, `Sys.Console`, `Sys.Modify`, `VM.Allocate`, `VM.Audit`, `VM.Clone`, `VM.Config.CDROM`, `VM.Config.CPU`, `VM.Config.Disk`, `VM.Config.HWType`, `VM.Config.Memory`, `VM.Config.Network`, `VM.Config.Options`, `VM.Monitor`, `VM.PowerMgmt` permissions on the Proxmox node.
*   **Proxmox Host:** Make sure that the Proxmox host is running and accessible from the machine where you are running Terraform.
*   **Cloud-init Template:** Verify that the cloud-init template exists and is configured correctly. It should be a minimal installation of a supported OS (e.g., Ubuntu Server) and should have the `qemu-guest-agent` installed.

### Ansible playbook fails to run

If the Ansible playbook fails to run, it may be due to a problem with your SSH connection. Check the following:

*   **SSH Key:** Make sure that your SSH key is added to your SSH agent (`ssh-add -l`).
*   **SSH Connection:** Try to connect to the nodes manually using SSH to verify that the connection is working.
*   **Ansible Inventory:** Double-check that the IP addresses in your Ansible inventory (`ansible/inventory/inventory.auto.yml`) are correct.

---

## Application and Networking Issues

### Application is not accessible

If an application is not accessible after it has been deployed, it may be due to a problem with the Traefik Ingress controller, the application itself, or your DNS configuration.

1.  **Check the Traefik Dashboard:** The Traefik dashboard provides a wealth of information about your Ingress routes and can help you diagnose problems. You can access it at `http://traefik.your-domain.com`.
2.  **Check the Application Logs:** Use `kubectl logs` to check the logs of the application's pods. This will often give you a clue as to what is wrong.
    ```bash
    kubectl logs -l app.kubernetes.io/name=<app-name> -n <namespace>
    ```
3.  **Check the IngressRoute:** Make sure that the `IngressRoute` for the application is configured correctly.
    ```bash
    kubectl get ingressroute -n <namespace>
    ```
4.  **Check DNS:** Verify that the DNS record for the application is pointing to the correct IP address (the IP address of your Traefik load balancer).

### Pods are stuck in a `Pending` state

If you see pods that are stuck in a `Pending` state, it usually means that there are not enough resources in the cluster to schedule them. You can use `kubectl describe pod <pod-name>` to get more information about why the pod is not being scheduled.

Common causes for this issue include:

*   **Insufficient CPU or memory:** The nodes in your cluster may not have enough CPU or memory to run the pod.
*   **Taints and tolerations:** The pod may not have the necessary tolerations to be scheduled on any of the available nodes.
*   **Persistent Volume Claims:** If the pod is requesting a Persistent Volume, there may not be a suitable Persistent Volume available to satisfy the claim.

---

## Restarting the Setup Process

If you encounter an issue that you cannot resolve, you can restart the setup process from the beginning.

1.  **Destroy the infrastructure:**
    ```bash
    make destroy
    ```
2.  **Delete the generated configuration files:**
    ```bash
    rm infrastructure/proxmox/terraform.tfvars
    rm ansible/inventory/inventory.auto.yml
    ```
3.  **Run the setup process again by following the steps in the [Getting Started](./getting-started.md) guide.**
