# Create Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.var_resource_group_name
  location = var.var_location
}

# Create Azure Virtual Network
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.var_virtual_network_name
  location            = var.var_location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]
}

# Create Azure Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.var_subnet_name
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Azure Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = var.var_public_ip_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.var_location
  allocation_method   = "Static"
}

# Create Azure Network Interface (NIC)
resource "azurerm_network_interface" "network_interface" {
  name                = var.var_nic_name
  location            = var.var_location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "${var.var_nic_name}_ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Create Azure Network Security Group (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = var.var_nsg_name
  location            = var.var_location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "TerraformAllowAllInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
