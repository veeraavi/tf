terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
  backend "azurerm"{

  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_virtual_network" "vnet" {
  resource_group_name = resource.azurerm_resource_group.rg.name
  name                = var.vnet_name
  location            = resource.azurerm_resource_group.rg.location
  address_space       = [var.vnet_addr]
}

resource "azurerm_subnet" "sn" {
  name                 = var.sbnet_vm
  resource_group_name  = resource.azurerm_resource_group.rg.name
  address_prefixes     = [var.sbnet_vm_addr]
  virtual_network_name = resource.azurerm_virtual_network.vnet.name
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vmname}-nic"
  resource_group_name = resource.azurerm_resource_group.rg.name
  location            = resource.azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "${var.vmname}-internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.sn.id
    public_ip_address_id          = resource.azurerm_public_ip.pip.id #We are mappin the public ip to the nic
    }
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.vmname}-pip"
  location            = resource.azurerm_resource_group.rg.location
  resource_group_name = resource.azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vmname
  resource_group_name             = resource.azurerm_resource_group.rg.name
  location                        = resource.azurerm_resource_group.rg.location
  size                            = "Standard_F2"
  admin_username                  = "loginadmin"
  admin_password                  = "Password@123"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic.id]  # By specifying list [] we can add mulitiplpe ips
   os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadOnly" # other possible values are "None", "ReadWrite"
    # disk_size_gb         = 20   i got below error when i use this 
    # "The specified disk size 20 GB is smaller than the size of the corresponding disk in the VM image: 30 GB. This is not allowed. Please choose equal or greater size or do not specify an explicit size." Target="osDisk.diskSizeGB"
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
