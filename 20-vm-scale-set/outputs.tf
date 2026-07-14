output "load_balancer_public_ip" {
  description = "Public IP address of the Azure Load Balancer"
  value       = azurerm_public_ip.public_ip.ip_address
}
