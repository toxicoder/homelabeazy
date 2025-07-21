#!/bin/bash

# This script configures a Proxmox VE node for homelab use.
# It disables the enterprise repository, enables the community repository,
# and disables the "No Valid Subscription" popup.

set -e

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
COMMUNITY_REPO_LINE="deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription"
if [ -f "$COMMUNITY_REPO_FILE" ]; then
    if grep -q "$COMMUNITY_REPO_LINE" "$COMMUNITY_REPO_FILE"; then
        echo "Community repository already enabled."
    else
        echo "$COMMUNITY_REPO_LINE" >> "$COMMUNITY_REPO_FILE"
        echo "Enabled community repository."
    fi
else
    echo "$COMMUNITY_REPO_LINE" > "$COMMUNITY_REPO_FILE"
    echo "Enabled community repository."
fi

# Disable "No Valid Subscription" popup
JS_FILE="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
if [ -f "$JS_FILE" ]; then
    if grep -q "if (data.status !== 'Active') {" "$JS_FILE"; then
        sed -i "s/if (data.status !== 'Active') {/if (false) {/" "$JS_FILE"
        echo "Disabled 'No Valid Subscription' popup."
    else
        echo "'No Valid Subscription' popup already disabled."
    fi
else
    echo "Proxmox javascript file not found. Skipping popup disable."
fi
