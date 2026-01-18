output "vm_public_ip" {
  value = azurerm_public_ip.subnet1_pip.*.ip_address
}