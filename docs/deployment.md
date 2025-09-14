---
layout: default
title: Deployment
nav_order: 5
category: documentation
---

# Deployment

> **Note:** The initial deployment of your homelab is handled by the interactive setup script, as described in the main `README.md`. This document provides more detail on the underlying deployment workflow and how to manage your environment after the initial setup.

This project uses Terraform workspaces to manage multiple environments. Each workspace represents a different environment (e.g., `dev`, `staging`, `prod`). The current workspace is determined by the `TF_WORKSPACE` environment variable.

## Environments

  * **dev:** The development environment. This is the default workspace. It is used for testing new features and changes.
  * **staging:** The staging environment. This workspace is used for testing changes before they are deployed to production.
  - **prod:** The production environment. This workspace is used for the live application.

## Managing Environments

You can switch between workspaces using the `terraform workspace select` command.

```bash
terraform workspace select <workspace-name>
```

For example, to switch to the `staging` workspace, you would run the following command:

```bash
terraform workspace select staging
```

## Promoting to Staging

To promote the current version of the `main` branch to the staging environment, you can manually trigger the `Promote to Staging` workflow.

1.  Go to the "Actions" tab of the repository.
2.  Select the "Promote to Staging" workflow.
3.  Click the "Run workflow" button.

## Promoting to Production

To promote the current version of the `staging` branch to the production environment, you can manually trigger the `Promote to Production` workflow. This workflow will merge the `staging` branch into the `main` branch and then deploy the changes to the production environment.

1.  Go to the "Actions" tab of the repository.
2.  Select the "Promote to Production" workflow.
3.  Click the "Run workflow" button.

# Deployment Workflow

This project follows a GitOps methodology for application deployment, with infrastructure managed as code. The workflow is as follows:

1.  **Provision Infrastructure:** Use Terraform to create the virtual machines for the K3s cluster on Proxmox. This is typically a one-time setup or for making infrastructure-level changes.

2.  **Configure Cluster:** Use Ansible to configure the K3s nodes, install necessary packages, and set up core components. This is also a one-time setup or for node-level configuration changes.

3.  **Deploy and Manage Applications:** Applications are managed by ArgoCD. To deploy, update, or remove an application, you make changes to the corresponding YAML files in the `apps/` directory and push them to your Git repository. ArgoCD automatically syncs these changes to the cluster.
