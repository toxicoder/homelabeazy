# Homelab as Code

This project uses Ansible to automate the setup of a homelab environment on a Proxmox server. It will provision a K3s cluster and deploy a set of core infrastructure and applications.

## Prerequisites

- Ansible 2.10+
- Access to a Proxmox VE 7.x server
- A registered domain name (or a local DNS server)

## Configuration

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/homelab-as-code.git
    cd homelab-as-code
    ```

2.  **Configure the inventory:**

    Edit the `ansible/inventory/hosts.yml` file to match your Proxmox server details and desired IP addresses for the K3s cluster.

3.  **Configure the variables:**

    Edit the `ansible/group_vars/all.yml` file to set your domain name, user passwords, and other configuration options.

## Usage

Once you have configured the inventory and variables, you can run the main playbook to set up your homelab:

```bash
ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/setup.yml
```

This will execute all the roles in the correct order to provision your homelab environment.
