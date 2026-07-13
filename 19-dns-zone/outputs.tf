output "load_balancer_public_ip" {
  description = "Public IP address of the Azure Load Balancer"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "dns_zone_name_servers" {
  description = "Azure DNS name servers for the DNS Zone"
  value       = azurerm_dns_zone.dns_zone.name_servers
}

output "dns_record_fqdn" {
  description = "Fully qualified domain name of the DNS A record"
  value       = azurerm_dns_a_record.dns_a_record.fqdn
}
