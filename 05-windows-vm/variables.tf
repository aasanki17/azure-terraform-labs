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
  description = "Name of the Subnet within the VNet"
}

variable "var_public_ip_name" {
  type        = string
  description = "Name of the Public IP Address"
}

variable "var_nic_name" {
  type        = string
  description = "Name of the Network Interface (NIC)"
}

variable "var_windows_vm_name" {
  type        = string
  description = "Name of the Windows Virtual Machine"
}

variable "var_admin_username" {
  type        = string
  description = "Admin username for the Windows VM"
}

variable "var_admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password for the Windows VM"
}
