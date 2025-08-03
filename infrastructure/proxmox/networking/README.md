# Networking

This document provides a detailed overview of the networking setup for this homelab.

## Network Segmentation

The network is segmented into the following VLANs:

*   **VLAN 10 (Service Network):** This network is used for the services running in the homelab, such as the K3s cluster and other applications.
*   **VLAN 20 (Guest Network):** This network is used for guest devices and is isolated from the rest of the network.
*   **VLAN 30 (Management Network):** This network is used for managing the Proxmox host and other infrastructure components.

## Service Discovery

Service discovery is provided by Consul. All services are automatically registered with Consul, which allows them to discover each other and communicate securely.

## Firewall Rules

Firewall rules are managed by pfSense. The firewall is configured to allow traffic between the VLANs according to the following rules:

*   The service network can access the internet.
*   The guest network can access the internet, but is isolated from all other networks.
*   The management network can access the internet and the service network.

## Ansible Configuration

The networking configuration is managed by the `homelab` Ansible role. This role is responsible for creating the network bridges and VLANs on the Proxmox host, and configuring the firewall rules.
