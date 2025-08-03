# Ansible Role: applications

This role deploys applications to a Kubernetes cluster using the `kubernetes.core.k8s` module.

## Description

This role iterates through all the `.yml` files in the `apps` directory at the root of the repository and applies them to the Kubernetes cluster. These YAML files are expected to be ArgoCD `Application` manifests.

## Role Variables

This role does not have any variables.

## Dependencies

This role requires the `kubernetes.core` collection to be installed.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - applications
```

## License

MIT
