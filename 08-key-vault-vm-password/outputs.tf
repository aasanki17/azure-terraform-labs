output "key_vault_name" {
  description = "Name of the Azure Key Vault"
  value       = azurerm_key_vault.key_vault.name
}

output "key_vault_secret_name" {
  description = "Name of the Key Vault secret storing the VM admin password"
  value       = azurerm_key_vault_secret.key_vault_secret.name
}
