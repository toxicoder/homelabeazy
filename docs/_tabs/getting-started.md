---
layout: default
title: Getting Started
parent: Guides
nav_order: 1
---

# Getting Started with Homelabeazy

Welcome to Homelabeazy! This guide will walk you through the process of setting up your very own homelab using this project. We'll cover everything from the initial setup to deploying your first application.

## Prerequisites

Before you begin, you'll need to have the following:

*   **A server with Proxmox VE installed:** This will be the foundation of your homelab.
*   **A Git repository:** This will be used to store your configuration. We recommend using a private repository on GitHub or a similar service.
*   **A basic understanding of the command line:** You'll need to be comfortable running commands in a terminal.
*   **A cup of coffee or tea:** This is optional, but highly recommended!

## Step 1: Clone the Repository

The first step is to clone the Homelabeazy repository to your local machine.

```bash
git clone https://github.com/homelabeazy/homelabeazy.git
cd homelabeazy
```

## Step 2: Interactive Setup

Next, you'll run the interactive setup script. This script will ask you a series of questions about your environment and then generate the necessary configuration files for you.

```bash
make setup-interactive
```

The script will guide you through the process of configuring your homelab. You'll be asked to provide information such as your Proxmox API credentials, your desired domain name, and the specifications for your virtual machines.

## Step 3: Provision the Infrastructure

Once the configuration files have been generated, you can provision the infrastructure using Terraform.

```bash
make terraform-apply
```

This command will create the virtual machines on your Proxmox server. This may take a few minutes to complete.

## Step 4: Configure the Cluster

After the virtual machines have been provisioned, you'll need to configure them using Ansible.

```bash
make ansible-playbook-setup
```

This command will install K3s on the virtual machines and configure them to form a Kubernetes cluster.

## Step 5: Post-Installation

After the setup is complete, you will need to perform the following steps to access your new homelab environment:

### 5.1. Configure DNS

You will need to configure DNS for your applications to be accessible at their respective domain names. This can be done by adding DNS records to your DNS provider or by using a local DNS server such as Pi-hole.

**Example: Using Pi-hole for Local DNS**

1.  Log in to your Pi-hole admin interface.
2.  Navigate to "Local DNS" -> "DNS Records".
3.  Add a new A record for your domain, pointing to the IP address of your Traefik load balancer. For example:

| Domain      | IP Address      |
| ----------- | --------------- |
| `*.example.com` | `192.168.1.100` |

This will resolve all subdomains of `example.com` to the IP address of your Traefik load balancer.

### 5.2. Access Applications

Once DNS is configured, you can access the applications by navigating to their respective domain names in your web browser.

**Example: Accessing Grafana**

1.  Open your web browser and navigate to `https://grafana.example.com`.
2.  You will be redirected to the Authelia login page.
3.  Log in with your credentials.
4.  You will then be redirected to the Grafana dashboard.

## Step 6: Deploy Your First Application

Congratulations, you now have a fully functional Kubernetes cluster! Now it's time to deploy your first application.

The Homelabeazy project uses ArgoCD for GitOps-based application deployment. To deploy a new application, you'll need to create a new YAML file in the `apps/` directory of your private configuration repository.

For example, to deploy a simple "Hello, World!" application, you could create a file named `hello-world.yml` with the following content:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: hello-world
  namespace: argocd
spec:
  project: default
  source:
    repoURL: 'https://github.com/your-username/your-private-repo.git'
    path: 'apps/hello-world'
    targetRevision: HEAD
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: default
```

Once you commit and push this file to your repository, ArgoCD will automatically detect the change and deploy the application to your cluster.

## What's Next?

You've now successfully set up your homelab and deployed your first application. Here are a few things you can do next:

*   **Explore the available applications:** The Homelabeazy project comes with a number of pre-configured applications that you can deploy to your cluster. Check out the `apps/` directory in the repository.
*   **Add your own applications:** You can easily add your own applications to your homelab by creating new Helm charts or by using existing ones.
*   **Customize your setup:** The Homelabeazy project is highly customizable. You can change the network configuration, add new services, and integrate with other systems.
*   **Contribute to the project:** If you've found a bug or have an idea for a new feature, we'd love to hear from you! Check out our [Contributing Guide](./community.md) for more information.
