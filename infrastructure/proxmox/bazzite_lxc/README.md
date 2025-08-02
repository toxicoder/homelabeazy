# Bazzite LXC for Proxmox

This directory contains Terraform configuration to create a Bazzite LXC container on a Proxmox server.

## Prerequisites

Before you can use this configuration, you must have a Bazzite LXC template available in your Proxmox environment. You will need to provide the name of this template in the `ostemplate` variable.

As official Bazzite LXC images may not be available, you might need to create your own.

## Usage

1.  Initialize Terraform in this directory:
    ```bash
    terraform init
    ```
2.  Create a `terraform.tfvars` file to specify the required variables, for example:
    ```terraform
    target_node = "pve"
    vmid        = 200
    ostemplate  = "local:vztmpl/bazzite-template.tar.gz"
    ```
3.  Apply the Terraform configuration:
    ```bash
    terraform apply
    ```

## Variables

| Name         | Description                                                                    | Type   | Default | Required |
|--------------|--------------------------------------------------------------------------------|--------|---------|----------|
| `hostname`   | The hostname of the Bazzite LXC.                                               | `string` | `bazzite` | No       |
| `target_node`| The Proxmox node to create the LXC on.                                         | `string` | n/a     | Yes      |
| `vmid`       | The VM ID of the LXC.                                                          | `number` | n/a     | Yes      |
| `memory`     | The amount of memory for the LXC in MB.                                        | `number` | `4096`  | No       |
| `cores`      | The number of CPU cores for the LXC.                                           | `number` | `2`     | No       |
| `ostemplate` | The Proxmox template to use for the LXC. This must be a Bazzite template.      | `string` | n/a     | Yes      |
