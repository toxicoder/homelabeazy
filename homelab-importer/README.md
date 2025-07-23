# Homelab Importer

A command-line tool to import data into a homelab environment.

## Why Use This Tool?

The Homelab Importer is designed to bridge the gap between your existing, manually-configured Proxmox environment and a more modern, automated setup using Infrastructure as Code (IaC). By using this tool, you can:

- **Automate your infrastructure:** Stop managing your Proxmox VMs and LXCs by hand. Let Terraform handle the provisioning and configuration of your homelab.
- **Simplify container management:** The importer discovers Docker containers running on your VMs and generates `docker-compose.yml` files, making it easy to redeploy and manage them.
- **Reduce complexity:** By consolidating your infrastructure into a single, version-controlled repository, you can more easily track changes, roll back to previous states, and share your setup with others.
- **Streamline migrations:** The importer provides a clear and repeatable process for migrating your existing homelab to a new, managed environment.

## Prerequisites

Before you begin, make sure you have the following installed and configured:

- **Python and Pip:** The importer is a Python script, so you'll need to have Python and Pip installed.
- **Terraform:** The importer generates Terraform configuration files, so you'll need to have Terraform installed to use them.
- **Docker Compose:** If you plan to use the generated `docker-compose.yml` files, you'll need to have Docker Compose installed on the target machine.
- **Proxmox API Credentials:** You'll need to have a Proxmox user with sufficient permissions to read VM/LXC configuration and access the API.

## Usage

The `homelab-importer` is a command-line tool that connects to your Proxmox API, discovers your existing VMs and LXCs, and generates a set of Terraform and Docker Compose files that you can use to manage your infrastructure.

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Set Up Environment Variables

Create a `.env` file in the `homelab-importer` directory and add your Proxmox API credentials:

```
PROXMOX_HOST=your_proxmox_host
PROXMOX_USER=your_proxmox_user
PROXMOX_PASSWORD=your_proxmox_password
```

### 3. Run the Importer

```bash
python src/main.py
```

This will generate the following files in the `output` directory:

- `homelab.tf`: Terraform configuration for your Proxmox resources.
- `terraform.tfvars`: Terraform variables for your resources.
- `import.sh`: A script to import your existing resources into Terraform state.
- `*_docker-compose.yml`: Docker Compose files for any discovered containers.

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Import Existing Resources

```bash
./import.sh
```

### 6. Apply the Terraform Configuration

```bash
terraform apply
```

### 7. Deploy Docker Containers

If `*_docker-compose.yml` files were generated, you can use them to deploy your Docker containers. Copy the relevant `docker-compose.yml` file to the target machine (e.g., a new VM created by Terraform) and run the following command:

```bash
docker-compose up -d
```

## Migration Strategy

The recommended migration strategy is to gradually bring your existing infrastructure under Terraform control without destroying any of your existing VMs or containers. The process is as follows:

### Step 1: Generate a Terraform Configuration

First, run the importer to generate the Terraform configuration files for your existing Proxmox resources.

```bash
python src/main.py
```

This will create `homelab.tf`, `terraform.tfvars`, and `import.sh`.

### Step 2: Initialize Terraform and Import

Next, initialize Terraform and use the generated `import.sh` script to import your existing resources into the Terraform state. This tells Terraform that it now "owns" these resources, so it won't try to recreate them.

```bash
terraform init
./import.sh
```

After running the import, you can run `terraform plan` to verify that Terraform does not intend to make any changes to your existing infrastructure.

### Step 3: Review and Deploy Docker Compose Files

The importer also generates `*_docker-compose.yml` files for any discovered Docker containers. You have two options for how to manage these:

**Option A: Redeploy on a New Host (Recommended)**

For a cleaner, more organized setup, we recommend provisioning a new VM or LXC to run your Docker containers. You can do this by adding a new `proxmox_vm_qemu` or `proxmox_lxc` resource to your `homelab.tf` file.

Once the new host is up and running, you can copy the `docker-compose.yml` file to it and run `docker-compose up -d` to redeploy your containers. This approach isolates your containerized applications and makes them easier to manage.

**Option B: Continue Running on Existing Hosts**

If you prefer to continue running your containers on their existing hosts, you can simply use the generated `docker-compose.yml` files to manage them in place. This is a good option if you're not ready to make any major changes to your infrastructure.

### Step 4: Decommission Old Resources (Optional)

Once you've successfully migrated your containers to a new host, you can safely decommission the old VMs or LXCs that were previously running them. You can do this by running `terraform destroy` on the old resources.

## Example Usage

To give you a better idea of what to expect, here are some examples of the files generated by the importer.

### `homelab.tf`

This file contains the Terraform configuration for your Proxmox resources.

```terraform
resource "proxmox_vm_qemu" "pve_vm_100" {
  name        = "ubuntu-vm"
  target_node = "pve"
  vmid        = 100
  # ... other configuration ...
}

resource "proxmox_lxc" "pve_lxc_101" {
  hostname    = "alpine-lxc"
  target_node = "pve"
  vmid        = 101
  # ... other configuration ...
}
```

### `terraform.tfvars`

This file contains the variables for your Terraform configuration.

```terraform
pve_vm_100 = {
  name        = "ubuntu-vm"
  target_node = "pve"
  vmid        = 100
  # ... other variables ...
}

pve_lxc_101 = {
  hostname    = "alpine-lxc"
  target_node = "pve"
  vmid        = 101
  # ... other variables ...
}
```

### `import.sh`

This script is used to import your existing resources into the Terraform state.

```bash
#!/bin/bash

terraform import proxmox_vm_qemu.pve_vm_100 pve/qemu/100
terraform import proxmox_lxc.pve_lxc_101 pve/lxc/101
```

### `*_docker-compose.yml`

This file is generated for any discovered Docker containers, making it easy to redeploy them.

```yaml
version: '3'
services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - /data/nginx:/usr/share/nginx/html
```
