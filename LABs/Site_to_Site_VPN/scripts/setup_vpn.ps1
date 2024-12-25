# Variables
$vpnPip = "4.247.178.193"      # Replace with the destination address of your VPN
$cloudNetwork = "10.0.0.0/8"  # Replace with your cloud network address space
$psk = "Azure1234"  # Replace with your PSK

# Add Remote Access Role
Install-WindowsFeature -Name RemoteAccess -IncludeManagementTools

# Add "Direct Access and VPN (RAS)" feature
Install-WindowsFeature -Name Routing -IncludeManagementTools

# Enable Routing and Remote Access
$service = Get-Service -Name RemoteAccess
if ($service.Status -ne "Running") {
    Install-RemoteAccess -VpnType VpnS2S
    Start-Service -Name RemoteAccess
}

# Configure Routing and Remote Access
Import-Module RemoteAccess
$ras = Get-RemoteAccess
if (!$ras) {
    # Enable Routing and Remote Access on the hostname
    netsh ras set routing mode=enable
}

# Create Demand-Dial Interface
$dialInterface = "VPNInterface"
Add-VpnS2SInterface -Name $dialInterface `
    -Protocol IKEv2 `
    -Destination $vpnPip `
    -AdminStatus $true `
    -AuthenticationMethod PSKOnly `
    -SharedSecret $psk `
    -IPv4Subnet "$($cloudNetwork):100" `
    -PassThru `
    -Persistent

# # Configure Static Routes
# New-NetRoute `
#     -InterfaceAlias $dialInterface `
#     -DestinationPrefix $cloudNetwork `
#     -NextHop $vpnPip

# # Configure Demand-Dial Connection
# $interfaceProperties = Get-VpnS2SInterface -Name $dialInterface

# # Set PSK and Persistent Connection
# $interfaceProperties.SharedSecret = $psk
# $interfaceProperties.AuthenticationMethod = "PresharedKey"
# $interfaceProperties.Type = "PersistentConnection"
# $interfaceProperties | Set-VpnS2SInterface

# Connect Demand-Dial Interface
Connect-VpnS2SInterface -Name $dialInterface

Write-Host "VPN setup completed successfully for $hostname." -ForegroundColor Green
