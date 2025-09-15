---
layout: default
title: Customization
nav_order: 5
category: "Guides"
---

# Customization

One of the core design principles of Homelabeazy is modularity. This means that you can easily customize the project to meet your specific needs. This guide will walk you through some of the most common customization tasks.

## Adding New Applications

The heart of your homelab is the applications you run on it. Homelabeazy uses a GitOps workflow with ArgoCD to manage applications, which makes it easy to add new ones. Here's the general process:

1.  **Find or create a Helm chart:** Most popular applications have official or community-maintained Helm charts. If not, you can create your own.
2.  **Create a `values.yaml` file:** In your private configuration repository, create a `values.yaml` file in `apps/<app-name>/` to store the configuration for the application. This file will override the default values in the Helm chart.
3.  **Create an ArgoCD Application manifest:** In the main `homelabeazy` repository, create a new YAML file in the `apps/` directory (e.g., `apps/<app-name>.yml`). This file will define an ArgoCD `Application` resource that points to the Helm chart and your `values.yaml` file.
4.  **Add the new application to the "app of apps":** Add a new entry for your application in the `apps/app-of-apps.yml` file. This will tell ArgoCD to start managing your new application.
5.  **Commit and push your changes:** Once you commit and push your changes to your Git repository, ArgoCD will automatically detect the new application and deploy it to your cluster.

For a more detailed walkthrough of this process, please see the [Adding New Applications](./adding-new-applications.md) guide.

## Managing Secrets

This project uses HashiCorp Vault to manage secrets. This provides a secure and centralized way to store and access sensitive information like API keys, passwords, and certificates.

The `secure_gen` Ansible role will automatically generate any secrets defined in the `secrets_to_generate` section of your `config.yml` file and store them in Vault. You can also manually add secrets to Vault using the Vault UI or CLI.

## Configuring Network Settings

All of the network settings for your homelab can be configured in your private `config.yml` file. This includes things like your domain name, the IP address of your load balancer, and the VLANs for your different network segments.

## Using a Different Cloud-Init Template

This project uses a cloud-init template to configure the virtual machines when they are first created. You can use a different cloud-init template by modifying the `proxmox_template` variable in your `terraform.tfvars` file.

Your custom cloud-init template should be based on a minimal Linux distribution (e.g., Ubuntu Server) and should have the `qemu-guest-agent` installed.
