resource "azurerm_resource_group" "example" {
    for_each = toset(var.rg)
    name     = each.value
    location = var.location
}