# Applications

This directory contains the ArgoCD Application manifests for the applications deployed in the homelab.

## Structure

Each application is defined in a separate YAML file. These files are ArgoCD `Application` resources that define how the application should be deployed.

The `app-of-apps.yml` file is the main entry point. It is an ArgoCD Application that deploys all the other applications in this directory.

## Configuration

The configuration for each application is stored in the `config/apps` directory. Each application has a `values.yaml` file that contains the Helm values for the application.
