# Private Deployment Guide

This project strongly recommends a private deployment workflow. This approach allows you to keep your private configuration, including secrets and customizations, in your own private Git repository, while still being able to pull in updates from the main `homelabeazy` repository.

## The Concept: Separating Public and Private Code

The key to this workflow is the separation of the public "application" code (the `homelabeazy` repository) from your private "configuration" code.

*   **Public Repository (`homelabeazy`):** This repository contains the core Ansible roles, Terraform modules, Helm chart templates, and other code that makes up the homelab infrastructure. You will treat this as an upstream dependency.
*   **Private Repository (Your Configuration):** This repository will contain all of your private configuration, including your `config.yml`, `terraform.tfvars`, and any custom application `values.yaml` files. This is the code that you will own and manage.

This separation allows you to:
*   Keep your secrets and private configuration completely isolated from the public repository.
*   Easily pull in updates from the `homelabeazy` repository without creating merge conflicts with your private configuration.
*   Version control your private configuration independently of the public codebase.

## Automated Setup

The recommended way to set up a private deployment is to use the interactive setup script, as described in the main `README.md`.

```bash
make setup-interactive
```

This script automates the entire process, including:
*   Prompting for the location of your private repository.
*   Discovering your existing homelab infrastructure.
*   Generating the necessary configuration files.
*   Committing the configuration to your private repository.

By using the interactive setup, you can avoid the manual steps that were previously required to set up a private deployment.

## Manual Setup (Advanced)

If you prefer to set up your private deployment manually, you can still do so. The basic steps are:

1. Create a private git repository for your configuration.
2. Copy the contents of the `config.example/` directory into your private repository.
3. Customize the configuration files to match your environment.
4. Create a symlink named `private` in the `homelabeazy` repository that points to your private configuration directory.
5. Run the deployment commands as usual (e.g., `make terraform-apply`, `make ansible-playbook-setup`).

## Updating

When there are updates to the `homelabeazy` repository, you can easily pull them in without affecting your private configuration.

1.  **Navigate to the `homelabeazy` directory:**
    ```bash
    cd homelabeazy
    ```

2.  **Pull the latest changes:**
    ```bash
    git pull origin main
    ```

Because your private configuration is in a separate repository, you won't have any merge conflicts. You can then re-run the deployment commands to apply the updates to your homelab.
