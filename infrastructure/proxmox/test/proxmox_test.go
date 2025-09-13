package test

import (
	"context"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformPlan(t *testing.T) {
	t.Parallel()

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	startMockProxmoxAPI(ctx)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"proxmox_api_url":          "https://localhost:8006/api2/json",
			"pm_token_id":              "user@pve!test",
			"pm_token_secret":          "dummy",
			"proxmox_node":             "pve",
			"proxmox_template":         "ubuntu-2204-cloud-init",
			"k3s_master_vm_id":         100,
			"k3s_worker_vm_id_start":   101,
			"pm_tls_insecure":          true,
			"stealth_vm_enabled":       true,
		},
	}

	// Run `terraform init` and `terraform plan`. Fail the test if there are any errors.
	terraform.InitAndPlan(t, terraformOptions)
}
