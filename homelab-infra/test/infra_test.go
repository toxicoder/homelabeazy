package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformProxmoxExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../terraform",
		Vars: map[string]interface{}{
			"pm_api_url":             "https://192.168.1.100:8006/api2/json",
			"pm_api_user":            "root@pam",
			"pm_api_password":        "password",
			"proxmox_host":           "pve",
			"template_name":          "ubuntu-2204-cloud-init",
			"template_vmid":          9000,
			"os_image_url":           "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img",
			"k3s_master_count":       1,
			"k3s_master_prefix":      "k3s-master",
			"k3s_master_cpu":         2,
			"k3s_master_memory":      2048,
			"k3s_master_disk_size":   "20G",
			"k3s_worker_count":       0,
			"k3s_worker_prefix":      "k3s-worker",
			"k3s_worker_cpu":         2,
			"k3s_worker_memory":      2048,
			"k3s_worker_disk_size":   "20G",
			"network_bridge":         "vmbr0",
			"network_vlan_tag":       -1,
			"network_gateway":        "192.168.1.1",
			"network_cidr":           "192.168.1.0/24",
			"ssh_public_key":         "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/8yv... user@host",
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	instanceName := terraform.Output(t, terraformOptions, "instance_name")

	// Verify that the instance name is what we expect
	assert.Equal(t, "k3s-master-1", instanceName)
}
