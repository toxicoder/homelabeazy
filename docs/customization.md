**Navigation**
* [Home](index.md)
* [Advanced Usage](advanced-usage.md)
* [Architecture](architecture.md)
* [Configuration](configuration.md)
* [Customization](customization.md)
* [Deployment](deployment.md)
* [Post Installation](post-installation.md)
* [Services](services.md)
* [Technical Design](technical-design.md)
* [Troubleshooting](troubleshooting.md)

---

# Customization

This project is highly customizable. You can add new applications, manage secrets, and configure network settings to fit your needs.

## Adding New Applications

To add a new application, you need to add a new ArgoCD application manifest to the `apps/` directory. This typically involves the following steps:

1.  **Find or create a Helm chart for the application.**
2.  **Create a new `values.yaml` file** in `private/apps/<app-name>/` to store the configuration for the application.
3.  **Create a new YAML file** in the `apps/` directory (e.g., `apps/<app-name>.yml`). This file will define an ArgoCD `Application` resource that points to the Helm chart and your `values.yaml` file.
4.  **Add the new application to `apps/app-of-apps.yml`** so that it is automatically deployed with the other applications.
5.  **Commit and push your changes** to the Git repository. ArgoCD will automatically deploy the new application.

## Managing Secrets

This project uses Vault to manage secrets by default. The `secure_gen` script will automatically generate any secrets defined in the `secrets_to_generate` section of your `private/config.yml` file and store them in Vault.

## Configuring Network Settings

All network settings can be configured in the `private/config.yml` file.

## Using Different Cloud-Init Templates

This project uses a cloud-init template to configure the virtual machines. You can use a different cloud-init template by modifying the `template_name` variable in the `terraform/terraform.tfvars` file.
