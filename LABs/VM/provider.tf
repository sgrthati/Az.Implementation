terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.7.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=3.0.2"
    }
  }
  backend "local" {
    path = "./dev/terraform.tfstate"
  }
}
provider "azurerm" {
  features {
  resource_group {
    prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}
provider "azuread" {
}