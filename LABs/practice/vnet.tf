# resource "azurerm_virtual_network" "example" {
#   name                = "${var.rg_name}-network"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   address_space       = [var.address_space]
#   tags = {
#     environment = local.tags
#   }
# }