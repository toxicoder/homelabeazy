---
layout: single
title: Deployment
category: "Reference"
---

# Deployment

This document provides an overview of the deployment process for the Homelabeazy documentation site.

## Documentation Site

The documentation site is a Jekyll-based site that is hosted on GitHub Pages. The site is automatically built and deployed by a GitHub Actions workflow whenever a change is pushed to the `main` branch.

The workflow is defined in the `.github/workflows/deploy-docs.yml` file. It performs the following steps:

1.  **Checkout:** The workflow checks out the code from the repository.
2.  **Setup Ruby:** It sets up the Ruby environment and installs the necessary gems, using a cache to speed up the process.
3.  **Build:** It builds the Jekyll site.
4.  **Test:** It runs `html-proofer` to check for broken links and other issues.
5.  **Deploy:** It deploys the built site to the `gh-pages` branch, which is then served by GitHub Pages.

## Homelab Deployment

The deployment of your homelab is handled by a combination of Terraform, Ansible, and ArgoCD.

### Infrastructure

The infrastructure for your homelab is provisioned using Terraform. You can apply the Terraform configuration by running the following command:

```bash
make terraform-apply
```

This will create the virtual machines on your Proxmox server.

### Configuration

After the virtual machines have been provisioned, you'll need to configure them using Ansible.

```bash
make ansible-playbook-setup
```

This will install K3s on the virtual machines and configure them to form a Kubernetes cluster.

### Applications

Applications are deployed to your cluster using a GitOps workflow with ArgoCD. To deploy a new application, you'll need to create a new YAML file in the `apps/` directory of your private configuration repository.

For more information on how to add new applications, please see the [Customization](./customization.md) guide.
