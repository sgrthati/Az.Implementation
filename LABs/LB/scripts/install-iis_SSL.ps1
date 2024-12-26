# Check if IIS is installed and install if not
if (-not (Get-WindowsFeature -Name Web-Server).Installed) {
    Write-Output "Installing IIS..."
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
    Write-Output "IIS installed successfully."
} else {
    Write-Output "IIS is already installed."
}

# Define the path to the default IIS directory
$defaultSitePath = "C:\inetpub\wwwroot"

# Stop IIS to make changes
Write-Output "Stopping IIS..."
Stop-Service -Name W3SVC -Force

# Get the hostname of the computer
$hostname = $env:COMPUTERNAME

# Define the metadata URL for VM location
$metadataUrl = "http://169.254.169.254/metadata/instance?api-version=2021-01-01"

# Fetch the VM metadata
try {
    $metadata = Invoke-RestMethod -Uri $metadataUrl -Headers @{Metadata="true"} -Method GET
    $location = $metadata.compute.location
} catch {
    Write-Output "Error fetching metadata: $_"
    $location = "Unknown"
}

# Display the location (for testing purposes)
Write-Output "VM Location: $location"

# Create a new index.html file with the hostname and location
$htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
</head>
<body>
    <h1>Welcome to $hostname</h1>
    <h2>Location: $location</h2>
</body>
</html>
"@

# Write the content to index.html
Write-Output "Creating custom default page..."
Set-Content -Path "$defaultSitePath\index.html" -Value $htmlContent -Force

# Ensure the default document is set to index.html
Write-Output "Setting default document..."
Import-Module WebAdministration
Set-ItemProperty IIS:\Sites\Default Web Site -Name defaultDocument.files -Value @("index.html")

# Start IIS
Write-Output "Starting IIS..."
Start-Service -Name W3SVC

Write-Output "Setup completed. Access your website at http://localhost."

# Define the path to the PFX file and the password
#to convert the PFX file to base64 format
# $pfxPath = "C:\Users\User\OneDrive\Cloud Computing\LABs\Az.Implementation\LABs\LB\scripts\certificate.pfx"
# $base64Pfx = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($pfxPath))
# $base64Pfx | Out-File -FilePath "C:\Users\User\OneDrive\Cloud Computing\LABs\Az.Implementation\LABs\LB\scripts\encoded.txt"
$base64Pfx = @"
MIIOTA*******************8qAgIIAA==
"@
$pfxBytes = [Convert]::FromBase64String($base64Pfx)
$outputPfxPath = "C:\Users\azureadmin\Downloads\certificate.pfx"
[System.IO.File]::WriteAllBytes($outputPfxPath, $pfxBytes)
$pfxPath = "C:\Users\azureadmin\Downloads\certificate.pfx"
$pfxPassword = ConvertTo-SecureString -String "secret" -AsPlainText -Force
$domain = "srisri.xyz"
$siteName = "Default Web Site"
$ipAddress = "*"
$port = 443

# Step 1: Import PFX into the Personal Certificate Store
Import-PfxCertificate -FilePath $outputPfxPath -CertStoreLocation Cert:\LocalMachine\My -Password $pfxPassword

# Step 2: Get the Thumbprint of the Imported Certificate
$certificateThumbprint = (Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -match "CN=$domain" }).Thumbprint
# Step 3: Check for existing binding and remove it if necessary
$binding = Get-WebBinding -Name $siteName -Protocol https -ErrorAction SilentlyContinue

if ($binding) {
    # Remove existing binding
    Remove-WebBinding -Name $siteName -IPAddress $ipAddress -Port $port -Protocol https
}

# Step 4: Create a new binding
New-WebBinding -Name $siteName -Protocol https -IPAddress $ipAddress -Port $port

# Step 5: Assign the Certificate to the Binding
cd IIS:\SslBindings
get-item Cert:\LocalMachine\MY\$CertificateThumbprint | New-Item 0.0.0.0!443

Write-Host "SSL Certificate successfully bound to $siteName" -ForegroundColor Green