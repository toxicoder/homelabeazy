# Homelab Importer

A command-line tool to import data into a homelab environment.

## Usage

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Set up environment variables:**
   - Create a `.env` file in the `homelab-importer` directory.
   - Add the following variables to the `.env` file, replacing the values with your Proxmox credentials:
     ```
     PROXMOX_HOST=your_proxmox_host
     PROXMOX_USER=your_proxmox_user
     PROXMOX_PASSWORD=your_proxmox_password
     ```

3. **Run the tool:**
   ```bash
   python src/main.py
   ```
