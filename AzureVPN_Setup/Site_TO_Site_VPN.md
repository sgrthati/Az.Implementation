# deploying VPN to OnPrem setup using Win2019 server

    1.we have to deploy 2 VirtualNetworks with different address spaces to avoid conflict

    2.deploy with a setup for CLOUD resources with `MultiAZ-VMCreationWithAssignedParameters.ps1`
        
        - $RG = "CLOUD"
        - $ADDRESS_SPACE = "10.0.0.0/16"
        - $SUBNET = "10.0.0.0/24"
        - no chnages in remaining template
    
    3.deploy OnPrem setup with same script by doing below chnages `MultiAZ-VMCreationWithAssignedParameters.ps1`

        - $RG = "OnPrem"
        - $ADDRESS_SPACE = "192.168.0.0/16"
        - $SUBNET = "192.168.0.0/24"
        - No chnages in remaining template
    
    4.deploy a GatewaySubnet in CLOUD_VNET

![image](https://github.com/sgrthati/Az.Implementation/assets/101870480/8c1c8479-d802-4412-9993-2523ccc021cc)

        
    5.start deploying "Virtual Network Gateway" using Gatewaysubnet,it may take 20 to 30min for provisioning

![image-1](https://github.com/sgrthati/Az.Implementation/assets/101870480/ed6f3009-a769-4e46-922f-36813936d3b5)

    6.while VPN provisioning,we will provision "Local Network Gateway"(here we are going to define the path for OnPremise)
        
![image-2](https://github.com/sgrthati/Az.Implementation/assets/101870480/d0a881f5-59eb-477b-856a-0355ac72b480)

    8.site-to-site configuration

        - "Add Connection" in VPN
![image-3](https://github.com/sgrthati/Az.Implementation/assets/101870480/4f2495d7-b6e0-48ef-aa0f-06f0523b678c)

    7.Now setup OnPrem VM for VPN setup

        - Add Roles and features
        - check "Remote Access" under "Server Roles"
        - check "Direct access and VPN(RAS)" under Remote Access"
        - in Win2019 Server > Tools > Routing And Remote Access > On Hostname( in my case OnPremVM1) > right click and enable Routing and Remote Access > then choose Custom and apply
        - Now Tree will be enabled for OnPremVM1
            - for Network interfaces Add "new Demand-Dial interface wizard"
            - Connect Using Virtual Private Network(VPN)
            - select VPN Type as IKEv2
            - Destination Address should be "VPN-PIP"(already created this one while provisioning VPN)
            - Static Route for Remote Networks > we have to mention address space of CLOUD Netowrk i.e 10.0.0.0/24
            - ignore Dial-out credentials,because we wanted to use PSK
            - new Demand-Dial interface will be created
        - now we have to pass PSK through the Properties of demand-dial connection
            - click on Properties
            - in Options > change "Connection Type" to "Persistent Connection"
            - in Security > here we have to pass PSK
            - save it
        - on Demand-Dial interface click on Connect



    8. 7th step can be achieved by using below script
            # Variables
            $vpnPip = "52.172.169.58"      # Replace with the destination address of your VPN
            $cloudNetwork = "10.0.0.0/8"  # Replace with your cloud network address space
            $psk = "Azure123"  # Replace with your PSK
            
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

