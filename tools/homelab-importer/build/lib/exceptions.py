class HomelabImporterError(Exception):
    """Base exception for the homelab importer."""


class ProxmoxAuthenticationError(HomelabImporterError):
    """Raised when there is an authentication error with the Proxmox API."""


class ProxmoxConnectionError(HomelabImporterError):
    """Raised when there is a connection error with the Proxmox API."""


class MissingEnvironmentVariableError(HomelabImporterError):
    """Raised when a required environment variable is not set."""
