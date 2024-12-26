data "azurerm_storage_account" "sa" {
  name = var.sa.name
  resource_group_name = var.sa.rg_name
}