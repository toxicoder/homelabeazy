# Private Deployment Guide

This guide provides a recommended workflow for deploying your homelab in a private, isolated environment. This approach allows you to keep your private configuration, including secrets and customizations, in your own private Git repository, while still being able to pull in updates from the main `homelabeazy` repository.

## The Concept: Separating Public and Private Code

The key to this workflow is the separation of the public "application" code (the `homelabeazy` repository) from your private "configuration" code.

*   **Public Repository (`homelabeazy`):** This repository contains the core Ansible roles, Terraform modules, Helm chart templates, and other code that makes up the homelab infrastructure. You will treat this as an upstream dependency.
*   **Private Repository (Your Configuration):** This repository will contain all of your private configuration, including your `config.yml`, `terraform.tfvars`, and any custom application `values.yaml` files. This is the code that you will own and manage.

This separation allows you to:
*   Keep your secrets and private configuration completely isolated from the public repository.
*   Easily pull in updates from the `homelabeazy` repository without creating merge conflicts with your private configuration.
*   Version control your private configuration independently of the public codebase.

## Step-by-Step Guide

### 1. Create a Private Git Repository

First, create a new, private Git repository on your preferred Git hosting service (e.g., GitHub, GitLab, Gitea). This repository will be used to store your private configuration.

### 2. Clone the Repositories

Next, clone both the `homelabeazy` repository and your new private repository to your local machine.

```bash
# Clone the public homelabeazy repository
git clone https://github.com/toxicoder/homelabeazy.git

# Clone your private configuration repository
git clone <your-private-repo-url> my-homelab-config
```

This will give you two directories: `homelabeazy` and `my-homelab-config`.

### 3. Set Up Your Private Configuration

Now, you will use the `homelabeazy` repository to generate your initial private configuration.

1.  **Navigate to the `homelabeazy` directory:**
    ```bash
    cd homelabeazy
    ```

2.  **Run the `make setup` command:**
    ```bash
    make setup
    ```
    This command will prompt you for your Proxmox credentials and domain name, and then it will create a new `private/` directory containing your initial configuration files.

3.  **Move the `private` directory to your private repository:**
    ```bash
    mv private ../my-homelab-config/
    ```

4.  **Commit and push your initial configuration:**
    ```bash
    cd ../my-homelab-config
    git add private
    git commit -m "Initial homelab configuration"
    git push origin main
    ```

You now have your private configuration stored in your own private Git repository.

### 4. Deploying Your Homelab

To deploy your homelab, you will need to symlink your private configuration directory into the `homelabeazy` repository.

1.  **Create a symlink from your private config to the `homelabeazy` directory:**
    ```bash
    cd ../homelabeazy
    ln -s ../my-homelab-config/private .
    ```
    This will create a `private` symlink in your `homelabeazy` directory that points to your private configuration. Because `private/` is in the `.gitignore` file, this symlink will not be tracked by git.

2.  **Run the deployment commands:**
    Now you can run the `make` commands to deploy your homelab, just as you would normally. The `Makefile` is configured to automatically use the `private/` directory for all configuration.
    ```bash
    # To apply the terraform and run the ansible playbooks
    make

    # Or, to run the steps individually
    make terraform-apply
    make ansible-playbook-setup
    ```

### 5. Managing Your Configuration

Any changes you want to make to your homelab configuration should be made in your `my-homelab-config` repository. This includes:
*   Editing `private/config.yml` to change global settings.
*   Editing `private/terraform.tfvars` to change infrastructure settings.
*   Editing `private/apps/<app-name>/values.yaml` to customize applications.

After making changes, be sure to commit and push them to your private repository.

### 6. Updating the Public Code

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
