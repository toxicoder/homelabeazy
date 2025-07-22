#!/bin/bash

# This script will be executed on the Windows guest to verify that the VM is not detected as a virtual machine.

powershell -Command "Get-ComputerInfo | Select CsHypervisorPresent"
