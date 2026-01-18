terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.16.0"
    }
  }
}
provider "azurerm" {
  # Configuration options
  features {
    
  }
  subscription_id = "549e90a6-40ca-4c76-8aa8-8f6ea2a287f4"
}