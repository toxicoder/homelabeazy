#This script runs a series of tests to determine if the machine is a virtual machine.
#It outputs the results in a JUnit XML file.

$testResults = @()

# Test 1: Check registry key
$regKeyPath = "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Virtualization"
$regKeyName = "IsVirtualMachine"
$expectedValue = 0

try {
    $regValue = (Get-ItemProperty -Path $regKeyPath -Name $regKeyName).$regKeyName
    if ($regValue -eq $expectedValue) {
        $testResults += @{
            Name      = "Registry Check"
            Status    = "Passed"
            Message   = "Registry key $regKeyName is set to $expectedValue."
        }
    } else {
        $testResults += @{
            Name      = "Registry Check"
            Status    = "Failed"
            Message   = "Registry key $regKeyName is not set to $expectedValue. Actual value: $regValue"
        }
    }
} catch {
    $testResults += @{
        Name      = "Registry Check"
        Status    = "Failed"
        Message   = "Registry key $regKeyName not found."
    }
}

# Test 2: WMI Manufacturer and Model
$manufacturer = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer
$model = (Get-WmiObject -Class Win32_ComputerSystem).Model

if ($manufacturer -eq "ASUS" -and $model -eq "ROG Strix") {
    $testResults += @{
        Name      = "WMI SMBIOS Check"
        Status    = "Passed"
        Message   = "WMI Manufacturer and Model are correctly spoofed."
    }
} else {
    $testResults += @{
        Name      = "WMI SMBIOS Check"
        Status    = "Failed"
        Message   = "WMI Manufacturer and Model are not correctly spoofed. Manufacturer: $manufacturer, Model: $model"
    }
}

# Test 3: MAC Address
$macAddress = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }).MACAddress
if ($macAddress -eq "00:11:22:33:44:55") {
    $testResults += @{
        Name      = "MAC Address Check"
        Status    = "Passed"
        Message   = "MAC address is correctly spoofed."
    }
} else {
    $testResults += @{
        Name      = "MAC Address Check"
        Status    = "Failed"
        Message   = "MAC address is not correctly spoofed. Actual: $macAddress"
    }
}

# Generate JUnit XML
$xmlPath = "C:\\Users\\Administrator\\Desktop\\results.xml"
$xml = "<testsuites>"
$xml += "<testsuite name='Stealth VM Tests'>"

foreach ($result in $testResults) {
    $xml += "<testcase name='$($result.Name)'>"
    if ($result.Status -eq "Failed") {
        $xml += "<failure message='$($result.Message)'></failure>"
    }
    $xml += "</testcase>"
}

$xml += "</testsuite>"
$xml += "</testsuites>"

$xml | Out-File -FilePath $xmlPath -Encoding utf8
