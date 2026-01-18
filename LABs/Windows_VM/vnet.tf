resource "azurerm_virtual_network" "vnet" {
    name = "${var.rg_name}-vnet"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = [var.vnet.address_space]
}
resource "azurerm_subnet" "subnet" {
    for_each = var.subnet
    name = each.key
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [each.value]  
}