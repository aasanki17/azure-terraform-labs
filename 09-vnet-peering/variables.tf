# Resource Configuration Variables
variable "var_location" {
  type        = string
  description = "Azure region"
}

variable "var_resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "var_virtual_network_name1" {
  type        = string
  description = "Name of the Virtual Network 1"
}

variable "var_virtual_network_name2" {
  type        = string
  description = "Name of the Virtual Network 2"
}

variable "var_vnetpeer1to2" {
  type        = string
  description = "Name of VNet peering from VNet1 to VNet2"
}

variable "var_vnetpeer2to1" {
  type        = string
  description = "Name of VNet peering from VNet2 to VNet1"
}
