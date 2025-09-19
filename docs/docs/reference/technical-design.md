---
title: Technical Design
parent: Reference
---

# Technical Design Document

## 1. Introduction

Welcome to the Technical Design Document for Homelabeazy. This document provides a detailed technical overview of the project, from its high-level architecture down to the individual components. Whether you're a user who wants to understand the inner workings of your homelab, or a contributor who wants to help improve the project, this document will serve as your guide.

### Who is this for?

This document is intended for users who have a basic understanding of the core technologies used in this project, such as Proxmox, Terraform, Ansible, and Kubernetes. If you're new to these technologies, we recommend that you start with our [Getting Started guide]({% link docs/guides/getting-started.md %}) and then come back to this document for a deeper dive.

### Design Philosophy

The design of Homelabeazy is guided by a set of core principles that are common in modern DevOps and Site Reliability Engineering (SRE) practices:

*   **Infrastructure as Code (IaC):** All infrastructure is defined as code, which allows for automation, versioning, and reproducibility.
*   **GitOps:** Git is the single source of truth for both infrastructure and applications. All changes are made through pull requests, which provides a clear audit trail and enables collaboration.
*   **Modularity:** The project is designed to be modular, so that you can easily add or remove components to suit your needs.
*   **Security by Design:** Security is a primary consideration in all aspects of the project, from network segmentation to secrets management.

---

## 2. Goals and Non-Goals

### 2.1. Goals

The primary goals of this project are to:

-   **Provide a complete blueprint for a modern homelab:** This project aims to be a comprehensive guide for building a powerful and flexible homelab environment.
-   **Automate everything:** From the provisioning of virtual machines to the deployment of applications, every aspect of the homelab should be automated.
-   **Ensure reproducibility:** You should be able to tear down and rebuild your entire homelab from scratch in a consistent and predictable manner.
-   **Promote best practices:** This project aims to demonstrate and encourage the use of enterprise-grade best practices for infrastructure management, such as IaC, GitOps, and security by design.
-   **Be highly customizable:** You should be able to easily customize the project to meet your specific needs, whether you want to add new applications, change the network configuration, or integrate with other systems.

### 2.2. Non-Goals

This project does not aim to:

-   **Be a one-size-fits-all solution:** While the project is highly customizable, it is not intended to be a universal solution for every homelab. It is designed for a specific set of technologies and use cases.
-   **Support other virtualization platforms:** The project is tightly coupled with Proxmox and does not support other hypervisors like ESXi or Hyper-V out of the box. However, the modular design of the project would allow for the addition of other providers in the future.
-   **Be a beginner-friendly project:** While we strive to make the documentation as clear as possible, a certain level of technical understanding of the core components (Terraform, Ansible, Kubernetes) is expected.
-   **Be a production-ready enterprise solution:** While this project uses enterprise-grade practices, it is intended for personal homelab use and is not recommended for production enterprise workloads without significant additional hardening and testing.

---

## 3. System Architecture

The architecture of Homelabeazy is a multi-layered system that builds upon a foundation of virtualization. It uses a combination of IaC and GitOps tools to automate the provisioning and configuration of a Kubernetes cluster and the applications that run on it.

<div class="mermaid">
graph TD
    subgraph "Hardware"
        A[Physical Server]
    end

    subgraph "Virtualization"
        B(Proxmox VE)
    end

    subgraph "Automation"
        C(Terraform) -- Provisions VMs on --> B
        D(Ansible) -- Configures Nodes --> E
    end

    subgraph "Container Orchestration & GitOps"
        E(K3s Kubernetes Cluster)
        K(ArgoCD) -- Deploys Apps to --> E
        L(Git Repository) -- Syncs with --> K
    end

    subgraph "Applications"
        F[Core Services]
        G[User Applications]
    end

    subgraph "Supporting Services"
        H(Traefik Ingress)
        I(Authelia SSO)
        J(Vault Secrets)
    end

    A --> B
    B --> E
    E -- Runs --> F
    E -- Runs --> G
    F -- Exposed by --> H
    G -- Exposed by --> H
    G -- Authenticated by --> I
    E -- Uses --> J
</div>

### System Architecture Walkthrough

The system architecture is designed to be a robust, scalable, and automated homelab environment. Here’s a step-by-step walkthrough of the diagram, explaining the role and value of each component:

1.  **Hardware (Physical Server):**

    - **Component:** `Physical Server`
    - **Role:** This is the foundation of the entire homelab, providing the necessary compute, memory, and storage resources.
    - **Value:** A dedicated physical server ensures that all virtualized components have direct access to high-performance hardware, leading to better overall performance and stability.

2.  **Virtualization (Proxmox VE):**

    - **Component:** `Proxmox VE`
    - **Role:** Proxmox is an open-source virtualization platform that runs on the physical server. It allows for the creation and management of virtual machines (VMs) and containers.
    - **Value:** Proxmox enables efficient hardware utilization by allowing multiple isolated environments to run on a single physical machine. This is crucial for creating a flexible and scalable infrastructure.

3.  **Automation (Terraform & Ansible):**

    - **Component:** `Terraform` & `Ansible`
    - **Role:**
        - `Terraform` is used to provision the virtual machines on Proxmox. It defines the infrastructure as code, making it easy to create, modify, and destroy VMs in a repeatable manner.
        - `Ansible` is used for configuration management. Once the VMs are provisioned, Ansible configures them and installs the necessary software like K3s.
    - **Value:** This combination of tools automates the entire setup process, reducing manual effort and ensuring consistency. It allows you to rebuild the entire homelab from scratch with minimal intervention.

4.  **Container Orchestration & GitOps (K3s & ArgoCD):**

    - **Component:** `K3s Kubernetes Cluster` & `ArgoCD`
    - **Role:**
        - `K3s` is a lightweight, certified Kubernetes distribution that runs on the VMs. It orchestrates the deployment, scaling, and management of containerized applications.
        - `ArgoCD` provides a GitOps workflow. It continuously monitors a Git repository and automatically deploys any changes to the K3s cluster, ensuring that the cluster state always matches the state defined in Git.
    - **Value:** Kubernetes provides a powerful and standardized platform for running applications. ArgoCD automates application deployment and management, making it easy to track changes, roll back to previous versions, and maintain a consistent environment.

5.  **Applications (Core Services & User Applications):**

    - **Component:** `Core Services` & `User Applications`
    - **Role:** The K3s cluster runs two types of applications:
        - `Core Services`: These are essential infrastructure components like monitoring, logging, and security services.
        - `User Applications`: These are the end-user applications that you want to run in your homelab, such as a password manager, Git service, or home automation platform.
    - **Value:** This separation allows you to manage the core infrastructure independently of the applications, making it easier to update and maintain both.

6.  **Supporting Services (Traefik, Authelia, Vault):**

    - **Component:** `Traefik Ingress`, `Authelia SSO`, `Vault Secrets`
    - **Role:**
        - `Traefik Ingress`: A reverse proxy and load balancer that manages external access to the applications running in the cluster.
        - `Authelia SSO`: Provides single sign-on and two-factor authentication for the applications, enhancing security.
        - `Vault Secrets`: A secure storage for secrets like API keys, passwords, and certificates.
    - **Value:** These services provide essential functionality for managing and securing the applications. Traefik simplifies routing, Authelia centralizes authentication, and Vault protects sensitive information.

### General Flow of the System

1.  **Provisioning:** `Terraform` provisions the virtual machines on `Proxmox`.
2.  **Configuration:** `Ansible` configures the VMs and installs the `K3s Kubernetes Cluster`.
3.  **Deployment:** `ArgoCD` monitors the Git repository and deploys the `Core Services` and `User Applications` to the `K3s` cluster.
4.  **Access:**
    - Users access the applications through the `Traefik Ingress`.
    - `Authelia SSO` intercepts the requests to handle authentication.
5.  **Secrets Management:** The applications and the cluster use `Vault` to securely retrieve their secrets.

---

## 4. Detailed Component Design

### 4.1. Proxmox

-   **Why Proxmox?** Proxmox was chosen for its rich feature set, its open-source nature, and its excellent API support, which is crucial for automation.
-   **Prerequisites:** A working Proxmox installation is required.
-   **VM Templates:** The project relies on a cloud-init compatible VM template to be present on the Proxmox server. This template is used by Terraform to clone new VMs. The template should be a minimal installation of a supported OS (e.g., Ubuntu Server).

### 4.2. Terraform

-   **Why Terraform?** Terraform is a popular and powerful IaC tool that allows you to define your infrastructure in a declarative way. It has excellent support for Proxmox and a wide range of other providers.
-   **Configuration:** The main configuration file is `main.tf`, which defines the Proxmox provider and the VM resources.
-   **Variables:** User-specific variables, such as Proxmox API credentials and VM specifications (CPU, memory, disk), are defined in `variables.tf` and should be set in a `terraform.tfvars` file.

### 4.3. Ansible

-   **Why Ansible?** Ansible is a simple and powerful configuration management tool that is agentless, which means that you don't need to install any special software on the managed nodes.
-   **Inventory:** Ansible's inventory is located in `ansible/inventory/`. A static inventory file is provided for the user to fill in with the IP addresses of the newly created VMs.
-   **Playbooks and Roles:** The project uses a combination of playbooks and roles to organize the Ansible code. This modular structure allows for easy extension and customization.

### 4.4. K3s Cluster

-   **Why K3s?** K3s is designed to be a single binary that is easy to install, manage, and scale. It is a great choice for homelab environments where resources may be limited.
-   **Architecture:** The cluster consists of one or more master nodes and one or more worker nodes.
-   **Storage:** The project is configured to use the default K3s storage provisioner (local-path-provisioner), which is suitable for single-node clusters or development environments. For multi-node clusters, a more robust storage solution like Longhorn or an NFS provisioner would be recommended.

### 4.5. ArgoCD

-   **Why ArgoCD?** ArgoCD is a popular and powerful GitOps tool that provides a clear and intuitive way to manage your applications.
-   **App of Apps Pattern:** The project uses the "app of apps" pattern, which allows for modular management of applications.

### 4.6. Networking

The project uses a VLAN-based network segmentation strategy to isolate traffic and enhance security.

-   **Traefik:** Traefik is a modern reverse proxy and load balancer that is used as the Ingress controller for the K3s cluster.
-   **Consul:** Consul is used for service discovery within the cluster.
-   **pfSense:** pfSense is a powerful open-source firewall and router that is used to manage the network.

### 4.7. Security

-   **Vault:** HashiCorp Vault is used for secrets management.
-   **Authelia:** Authelia is an open-source authentication and authorization server providing two-factor authentication and single sign-on (SSO).
-   **OpenLDAP:** OpenLDAP is used as the central user directory.

### 4.8. Monitoring and Logging

-   **EFK Stack:** The project uses the EFK stack (Elasticsearch, Fluentd, and Kibana) for centralized logging.

### 4.9. Backup and Recovery

-   **Velero:** Velero is used for backing up and restoring the Kubernetes cluster.

---

## 5. Scalability and Customization

This project is designed to be both scalable and customizable. You can easily scale your cluster by adding more worker nodes, and you can customize the project by adding your own applications, configuring services, and modifying the infrastructure. For detailed instructions, please refer to the [Customization Guide]({% link docs/guides/customization.md %}).

---

## 6. Roadmap

This project is continuously evolving. Here are some potential future enhancements:

-   **Multi-Cloud Support:** Adding support for other cloud providers like AWS, GCP, or Azure.
-   **Advanced Networking:** Implementing more advanced networking policies using a service mesh like Istio or Linkerd.
-   **High Availability:** Setting up a multi-master K3s cluster for high availability of the control plane.
-   **Automated Backups:** Creating a more automated backup and restore workflow.
