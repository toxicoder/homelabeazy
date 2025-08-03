#!/bin/bash

# This script configures a Proxmox VE node for homelab use.
# It disables the enterprise repository, enables the community repository,
# and disables the "No Valid Subscription" popup.

set -e

# Function to enable a repository
enable_repo() {
    local repo_file="$1"
    local repo_line="$2"
    local repo_name="$3"

    if [ -f "$repo_file" ]; then
        if grep -q "$repo_line" "$repo_file"; then
            echo "$repo_name repository already enabled."
        else
            echo "$repo_line" >> "$repo_file"
            echo "Enabled $repo_name repository."
        fi
    else
        echo "$repo_line" > "$repo_file"
        echo "Enabled $repo_name repository."
    fi
}

# Disable enterprise repository
ENTERPRISE_REPO_FILE="/etc/apt/sources.list.d/pve-enterprise.list"
if [ -f "$ENTERPRISE_REPO_FILE" ]; then
    if ! grep -q "^#" "$ENTERPRISE_REPO_FILE"; then
        sed -i 's/^deb/#deb/' "$ENTERPRISE_REPO_FILE"
        echo "Disabled enterprise repository."
    else
        echo "Enterprise repository already disabled."
    fi
else
    echo "Enterprise repository file not found. Assuming it's already disabled."
fi

# Enable community repository
COMMUNITY_REPO_FILE="/etc/apt/sources.list.d/pve-community.list"
COMMUNITY_REPO_LINE=${PROXMOX_COMMUNITY_REPO:-"deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription"}
enable_repo "$COMMUNITY_REPO_FILE" "$COMMUNITY_REPO_LINE" "Community"

# "No Valid Subscription" popup removal has been deprecated.
# This was previously handled by a sed command, which is not a robust solution.
# A better approach is to use a subscription or other supported methods.
