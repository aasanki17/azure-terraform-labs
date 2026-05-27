output "public_ip_address" {
  description = "Public IP address created for the network interface"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "network_security_group_name" {
  description = "Name of the Network Security Group"
  value       = azurerm_network_security_group.nsg.name
}
