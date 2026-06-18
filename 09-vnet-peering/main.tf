# Create Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Virtual Network 1
resource "azurerm_virtual_network" "virtual_network1" {
  name                = var.virtual_network_1_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Virtual Network 2
resource "azurerm_virtual_network" "virtual_network2" {
  name                = var.virtual_network_2_name
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Peering from VNet 1 to VNet 2
resource "azurerm_virtual_network_peering" "vnet_peering1" {
  name                      = var.vnet_1_to_vnet_2_peering_name
  resource_group_name       = azurerm_resource_group.resource_group.name
  virtual_network_name      = azurerm_virtual_network.virtual_network1.name
  remote_virtual_network_id = azurerm_virtual_network.virtual_network2.id

  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

# Peering from VNet 2 to VNet 1
resource "azurerm_virtual_network_peering" "vnet_peering2" {
  name                      = var.vnet_2_to_vnet_1_peering_name
  resource_group_name       = azurerm_resource_group.resource_group.name
  virtual_network_name      = azurerm_virtual_network.virtual_network2.name
  remote_virtual_network_id = azurerm_virtual_network.virtual_network1.id

  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}
