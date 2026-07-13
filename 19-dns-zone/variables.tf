# Resource Configuration Variables
variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the Azure Virtual Network"
}

variable "subnet_name" {
  type        = string
  description = "Name of the Azure Subnet"
}

variable "network_security_group_name" {
  type        = string
  description = "Name of the Azure Network Security Group"
}

variable "availability_set_name" {
  type        = string
  description = "Name of the Azure Availability Set"
}

variable "public_ip_name" {
  type        = string
  description = "Name of the Azure Public IP Address"
}

variable "load_balancer_name" {
  type        = string
  description = "Name of the Azure Load Balancer"
}

variable "frontend_ip_configuration_name" {
  type        = string
  description = "Name of the Load Balancer frontend IP configuration"
}

variable "backend_pool_name" {
  type        = string
  description = "Name of the Load Balancer backend address pool"
}

variable "health_probe_name" {
  type        = string
  description = "Name of the Load Balancer health probe"
}

variable "load_balancing_rule_name" {
  type        = string
  description = "Name of the Load Balancer rule"
}

variable "network_interface_name_1" {
  type        = string
  description = "Name of the first Azure Network Interface"
}

variable "network_interface_name_2" {
  type        = string
  description = "Name of the second Azure Network Interface"
}

variable "ip_configuration_name_1" {
  type        = string
  description = "Name of the first IP configuration for the Network Interface"
}

variable "ip_configuration_name_2" {
  type        = string
  description = "Name of the second IP configuration for the Network Interface"
}

variable "windows_vm_name_1" {
  type        = string
  description = "Name of the first Azure Windows Virtual Machine"
}

variable "windows_vm_name_2" {
  type        = string
  description = "Name of the second Azure Windows Virtual Machine"
}

variable "os_disk_name_1" {
  type        = string
  description = "Name of the OS disk for the first Windows Virtual Machine"
}

variable "os_disk_name_2" {
  type        = string
  description = "Name of the OS disk for the second Windows Virtual Machine"
}

variable "vm_extension_name_1" {
  type        = string
  description = "Name of the Custom Script Extension for the first Windows Virtual Machine"
}

variable "vm_extension_name_2" {
  type        = string
  description = "Name of the Custom Script Extension for the second Windows Virtual Machine"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the Windows Virtual Machine"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password for the Windows Virtual Machine"
}

variable "dns_zone_name" {
  type        = string
  description = "Name of the Azure DNS Zone"
}

variable "dns_record_name" {
  type        = string
  description = "Name of the DNS A record"
}

variable "dns_record_ttl" {
  type        = number
  description = "TTL value for the DNS A record"
}
