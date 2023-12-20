terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
  backend "azurerm"{
    #resource_group_name = var.rg_name
    #storage_account_name = "tfstate193"
    #container_name = "tfstate"
    #key = "dev.tfstate"
  }
}



provider "azurerm" {
    features{}
}

resource "azurerm_resource_group" "rg" {
    name = var.rg_name
    location = var.rg_location
}

resource "azurerm_virtual_network" "vnet" {
    resource_group_name = resource.azurerm_resource_group.rg.name
    name = var.vnet_name
    location = resource.azurerm_resource_group.rg.location
    address_space = [var.vnet_addr]
}

resource "azurerm_subnet" "sn" {
    name = var.sbnet_vm
    resource_group_name = resource.azurerm_resource_group.rg.name
    address_prefixes = [var.sbnet_vm_addr]
    virtual_network_name = resource.azurerm_virtual_network.vnet.name
}
