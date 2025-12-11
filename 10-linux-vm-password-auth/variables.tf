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
  description = "Name of the Virtual Network"
}

variable "var_subnet_name" {
  type        = string
  description = "Name of the Subnet"
}

variable "var_public_ip_name" {
  type        = string
  description = "Name of the Public IP"
}

variable "var_nic_name" {
  type        = string
  description = "Name of the Network Interface"
}

variable "var_nsg_name" {
  type        = string
  description = "Name of the Network Security Group"

}

variable "var_linux_vm_name" {
  type        = string
  description = "Name of the Linux Virtual Machine"
}

variable "var_admin_username" {
  type        = string
  description = "Admin username for the Linux VM"
}

variable "var_admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password for the Linux VM"
}
