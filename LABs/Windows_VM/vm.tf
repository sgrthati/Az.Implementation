# Create public IPs
resource "azurerm_public_ip" "subnet1_pip" {
    count                = "${var.vm.count}"
    name                 = "${var.rg_name}-SN1-vm-pip-${count.index+1}"
    location             = var.location
    resource_group_name  = azurerm_resource_group.rg.name
    allocation_method    = "Static"
    sku                  = "Standard"
}

# Create network interface
resource "azurerm_network_interface" "subnet1_nic" {
    count               = var.vm.count
    name                = "${var.rg_name}-SN1-vm-nic-${count.index+1}"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.subnet["SN1"].id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.subnet1_pip[count.index].id}"
    }
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "vm_instance1" {
    count                    = var.vm.count
    name                     = "${var.rg_name}-SN1-vm-${count.index+1}"
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = var.location
    size                     = "Standard_B4ms"
    admin_username           = var.vm.username
    admin_password           = var.vm.password
    network_interface_ids    = [azurerm_network_interface.subnet1_nic[count.index].id]
    vm_agent_platform_updates_enabled = true
    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    source_image_reference {
        publisher = "microsoftwindowsdesktop"
        offer     = "windows-11"
        sku       = "win11-22h2-entn"
        version   = "latest"
    }
}

# resource "azurerm_virtual_machine_extension" "iis_install_1" {
#   count                = var.vm.count
#   name                 = "iis-install"
#   virtual_machine_id   = azurerm_windows_virtual_machine.vm_instance1[count.index].id
#   publisher             = "Microsoft.Compute"
#   type                  = "CustomScriptExtension"
#   type_handler_version       = "1.8"
#   auto_upgrade_minor_version = true
#   settings = <<SETTINGS
#     {
#       "commandToExecute": "powershell -encodedCommand ${textencodebase64(file("${path.module}/scripts/install-iis.ps1"), "UTF-16LE")}"
#     }
#   SETTINGS
# }