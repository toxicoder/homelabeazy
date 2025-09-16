---
layout: default
title: Folder Structure
nav_order: 7
---

# Folder Structure

This document provides an overview of the folder structure of the Homelabeazy project.

-   `.github/`: This directory contains the GitHub Actions workflows for continuous integration and deployment.
-   `ansible/`: This directory holds the Ansible playbooks, roles, and inventory for configuring your homelab.
    -   `inventory/`: The Ansible inventory, which defines the hosts that Ansible will manage.
    -   `playbooks/`: The Ansible playbooks, which define the tasks that will be executed on the hosts.
    -   `roles/`: The Ansible roles, which are reusable units of automation that can be shared between playbooks.
-   `apps/`: This directory contains the ArgoCD application manifests for the applications that will be deployed to your cluster.
-   `charts/`: This directory contains the Helm charts for the applications that are not available in a public chart repository.
-   `config.example/`: This directory contains example configuration files to help you set up your own private configuration repository.
-   `docs/`: This directory contains the documentation for the project.
-   `infrastructure/`: This directory contains the Terraform code for provisioning the infrastructure for your homelab.
-   `scripts/`: This directory contains a collection of utility scripts for managing your homelab.
-   `tools/`: This directory contains various tools and utilities, such as the `homelab-importer`.
