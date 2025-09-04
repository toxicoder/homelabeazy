#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Helper Functions ---

# Function to print a message in a consistent format
info() {
    echo "INFO: $1"
}

# Function to print an error message and exit
error() {
    echo "ERROR: $1" >&2
    exit 1
}

# --- Main Script ---

info "Welcome to the Homelabeazy Interactive Setup!"
info "This script will guide you through setting up your homelab."

# 1a. Prompt for private configuration repository
read -p "Enter the local path to your private configuration git repository: " private_repo_path

if [ ! -d "$private_repo_path" ] || [ ! -d "$private_repo_path/.git" ]; then
    error "The path '$private_repo_path' is not a valid git repository. Please clone it first."
fi

info "Private repository confirmed at: $private_repo_path"

# 1b. Guide the user through running the homelab-importer
info "Next, we will run the homelab-importer to discover your existing infrastructure."
info "This will not make any changes to your homelab yet."

# Navigate to the homelab-importer tool directory
if [ ! -d "tools/homelab-importer" ]; then
    error "The 'tools/homelab-importer' directory does not exist. Please ensure you are running this script from the root of the homelabeazy repository."
fi
cd tools/homelab-importer

# Check for and install python dependencies
if [ -f "requirements.txt" ]; then
    info "Installing python dependencies for the importer..."
    pip install -r requirements.txt
else
    info "No requirements.txt found for the importer, skipping pip install."
fi


# Run the importer
info "Running the homelab-importer..."
# Note: Assuming homelab-importer takes an --output-dir argument.
# We will place the output directly into the user's private repo.
python src/main.py --output-dir "$private_repo_path/homelab_config"

info "Homelab importer has finished."
cd ../.. # Return to the root of the homelabeazy repository

# 1c. Place generated configuration into the user's private repository
# This is done by the --output-dir argument above.

# 1d. Run terraform import
info "Now, let's import your existing infrastructure into Terraform's state."
info "This will allow Terraform to manage your resources without recreating them."

cd "$private_repo_path/homelab_config/terraform"

info "Initializing Terraform..."
terraform init

info "Running the import script..."
# The importer is expected to generate an import.sh script
if [ -f "../import.sh" ]; then
    # The import script is in the parent directory of the terraform files
    bash ../import.sh
else
    error "The import.sh script was not found. The homelab-importer may have failed."
fi

info "Terraform import complete."
cd - # Return to the previous directory (homelabeazy root)

# 1e. Deploy the core services
info "Now we will deploy the core services for your homelab."
info "This will be done using Ansible."

# Symlink the private config to the expected location
if [ -L "private" ]; then
    rm private
elif [ -d "private" ]; then
    error "'private' directory exists and is not a symlink. Please remove it before running this script."
fi

ln -s "$private_repo_path/homelab_config" private
info "Symlinked your private config to the 'private' directory."

info "Running the main Ansible playbook..."
# Assuming a main playbook exists to set up core services
ansible-playbook ansible/playbooks/main.yml

info "Core services deployment complete."

# 1f. Commit the final configuration
info "Finally, let's commit the generated configuration to your private repository."

cd "$private_repo_path"
git add .
git commit -m "Initial homelab configuration from homelabeazy"
info "Configuration has been committed to your private repository."
info "You may now push the changes to your remote repository."

info "Interactive setup is complete! Enjoy your homelab."
