# Create public IPs
resource "azurerm_public_ip" "subnet1_pip" {
    for_each = var.vnet
    name                 = "${var.rg_name}-${each.key}-vm-pip"
    location             = var.location
    resource_group_name  = azurerm_resource_group.rg.name
    allocation_method    = "Static"
    sku                  = "Standard"
}

# Create network interface
resource "azurerm_network_interface" "subnet1_nic" {
    for_each = var.vnet
    name                = "${var.rg_name}-${each.key}-vm-nic"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.subnet[each.key].id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.subnet1_pip[each.key].id}"
    }
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "vm_instance1" {
    for_each = var.vnet
    name                     = "${var.rg_name}-${each.key}-vm"
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = var.location
    size                     = "Standard_B2ms"
    admin_username           = var.vm.username
    admin_password           = var.vm.password
    network_interface_ids    = [azurerm_network_interface.subnet1_nic[each.key].id]
    vm_agent_platform_updates_enabled = true
    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    source_image_reference {
        publisher = "microsoftwindowsserver"
        offer     = "windowsserver"
        sku       = "2019-datacenter"
        version   = "latest"
    }
}

resource "azurerm_virtual_machine_extension" "iis_install_1" {
  for_each = var.vnet
  name                 = "iis-install"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm_instance1[each.key].id
  publisher             = "Microsoft.Compute"
  type                  = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true
  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -encodedCommand ${textencodebase64(file("${path.module}/scripts/install-iis.ps1"), "UTF-16LE")}"
    }
  SETTINGS
}