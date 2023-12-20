variable "rg_name" {
  type = string
  description = "This variable is for resource group name"
}

variable "rg_location" {
  type = string
  description = "This variable is for resource group location"
}

variable "vnet_name" {
    type = string
    description = "This variable for virtual network name"
}

variable "vnet_addr" {
    type = string
    description = "This variable is for virtual network name"
}

variable "sbnet_vm" {
    type = string
    description = "This variable is for VM subnet name"
}

variable "sbnet_vm_addr" {
    type = string
    description = "This variable is for VM subnet address range"  
}