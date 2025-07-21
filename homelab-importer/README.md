# Homelab Importer

A command-line tool to import data into a homelab environment.

## Usage

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Set up environment variables:**
   - Create a `.env` file in the `homelab-importer` directory.
   - Add the following variables to the `.env` file, replacing the values with your Proxmox credentials:
     ```
     PROXMOX_HOST=your_proxmox_host
     PROXMOX_USER=your_proxmox_user
     PROXMOX_PASSWORD=your_proxmox_password
     ```

3. **Run the tool:**
   ```bash
   python src/main.py
   ```
   This will generate the following files:
   - `homelab.tf`: Terraform configuration for your Proxmox resources.
   - `terraform.tfvars`: Terraform variables for your resources.
   - `import.sh`: A script to import your existing resources into Terraform state.
   - `*_docker-compose.yml`: Docker Compose files for any discovered containers.

4. **Initialize Terraform:**
   ```bash
   terraform init
   ```

5. **Import existing resources:**
   ```bash
   ./import.sh
   ```

6. **Apply the Terraform configuration:**
   ```bash
   terraform apply
   ```

7. **Deploy Docker Containers:**
   - If `*_docker-compose.yml` files were generated, you can use them to deploy your Docker containers.
   - Copy the relevant `docker-compose.yml` file to the target machine (e.g., a new VM created by Terraform).
   - Run the following command to start the containers:
     ```bash
     docker-compose up -d
     ```

## Migration Strategy

The recommended migration strategy for importing your existing homelab resources is as follows:

1. **Run the importer:**
   - Execute the `homelab-importer` tool to generate Terraform code for your existing VMs/LXCs and `docker-compose.yml` files for your containers.

2. **Import Proxmox infrastructure:**
   - Use the generated `import.sh` script to bring your Proxmox infrastructure under Terraform control. This will import your VMs and LXCs into the Terraform state.

3. **Review Docker Compose files:**
   - Carefully review the generated `docker-compose.yml` files. These files define the services, networks, and volumes for your containerized applications.

4. **Provision a new host for containers (Optional but Recommended):**
   - For a cleaner setup, it's recommended to provision a new, dedicated VM or LXC for running your containers. You can do this using the Terraform code generated in the previous steps.

5. **Redeploy containerized applications:**
   - Apply the `docker-compose.yml` files on the new host to redeploy your containerized applications. This effectively migrates them out of their original, unmanaged locations and brings them under the management of Docker Compose.
