# Resource Configuration Variables
variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "virtual_network_1_name" {
  type        = string
  description = "Name of the first Azure Virtual Network"
}

variable "virtual_network_2_name" {
  type        = string
  description = "Name of the second Azure Virtual Network"
}

variable "vnet_1_to_vnet_2_peering_name" {
  type        = string
  description = "Name of the VNet peering from VNet 1 to VNet 2"
}

variable "vnet_2_to_vnet_1_peering_name" {
  type        = string
  description = "Name of the VNet peering from VNet 2 to VNet 1"
}
