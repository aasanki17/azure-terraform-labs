# Resource Configuration Variables
variable "var_location" {
  type        = string
  description = "Azure region"
}

variable "var_resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "var_virtual_network_name" {
  type        = string
  description = "Name of the Virtual Network (VNet)"
}

variable "var_subnet_name" {
  type        = string
  description = "Name of the Subnet within the Virtual Network"
}

variable "var_public_ip_name" {
  type        = string
  description = "Name of the Public IP Address"
}

variable "var_nic_name" {
  type        = string
  description = "Name of the Network Interface Card (NIC)"
}

variable "var_nsg_name" {
  type        = string
  description = "Name of the Network Security Group (NSG)"
}
