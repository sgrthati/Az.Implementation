resource "azurerm_virtual_network" "vnet" {
    for_each = var.vnet
    name = "${var.rg_name}-${each.key}"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = [each.value.address_space]
}
resource "azurerm_subnet" "subnet" {
    for_each = var.vnet
    name = "${var.rg_name}-subnet-${each.key}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet[each.key].name
    address_prefixes = [each.value.subnet]  
}