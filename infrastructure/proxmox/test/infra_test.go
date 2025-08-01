package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformProxmoxExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "..",
		Vars: map[string]interface{}{
			"pm_api_url":             os.Getenv("PROXMOX_API_URL"),
			"pm_api_user":            os.Getenv("PROXMOX_API_USER"),
			"pm_api_password":        os.Getenv("PROXMOX_API_PASSWORD"),
			"proxmox_host":           os.Getenv("TERRAFORM_TEST_PROXMOX_HOST"),
			"template_name":          os.Getenv("TERRAFORM_TEST_TEMPLATE_NAME"),
			"template_vmid":          os.Getenv("TERRAFORM_TEST_TEMPLATE_VMID"),
			"os_image_url":           os.Getenv("TERRAFORM_TEST_OS_IMAGE_URL"),
			"k3s_master_count":       1,
			"k3s_master_prefix":      os.Getenv("TERRAFORM_TEST_K3S_MASTER_PREFIX"),
			"k3s_master_cpu":         os.Getenv("TERRAFORM_TEST_K3S_MASTER_CPU"),
			"k3s_master_memory":      os.Getenv("TERRAFORM_TEST_K3S_MASTER_MEMORY"),
			"k3s_master_disk_size":   os.Getenv("TERRAFORM_TEST_K3S_MASTER_DISK_SIZE"),
			"k3s_worker_count":       0,
			"k3s_worker_prefix":      os.Getenv("TERRAFORM_TEST_K3S_WORKER_PREFIX"),
			"k3s_worker_cpu":         os.Getenv("TERRAFORM_TEST_K3S_WORKER_CPU"),
			"k3s_worker_memory":      os.Getenv("TERRAFORM_TEST_K3S_WORKER_MEMORY"),
			"k3s_worker_disk_size":   os.Getenv("TERRAFORM_TEST_K3S_WORKER_DISK_SIZE"),
			"network_bridge":         os.Getenv("TERRAFORM_TEST_NETWORK_BRIDGE"),
			"network_vlan_tag":       os.Getenv("TERRAFORM_TEST_NETWORK_VLAN_TAG"),
			"network_gateway":        os.Getenv("TERRAFORM_TEST_NETWORK_GATEWAY"),
			"network_cidr":           os.Getenv("TERRAFORM_TEST_NETWORK_CIDR"),
			"ssh_public_key":         os.Getenv("TERRAFORM_TEST_SSH_PUBLIC_KEY"),
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
