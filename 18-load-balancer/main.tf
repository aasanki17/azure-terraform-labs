# Current timestamp for SAS token generation
resource "time_static" "now" {}

# Create Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Virtual Network
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Azure Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create Azure Storage Account for IIS configuration script
resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Storage Container for scripts
resource "azurerm_storage_container" "storage_container" {
  name                  = var.storage_container_name
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

# Upload IIS configuration script to Blob Storage
resource "azurerm_storage_blob" "iis_script" {
  name                   = var.storage_blob_name
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.storage_container.name
  type                   = "Block"
  source                 = "${path.module}/IIS_Config.ps1"
}

# Generate SAS token for the IIS configuration script
data "azurerm_storage_account_sas" "storage_sas" {
  connection_string = azurerm_storage_account.storage_account.primary_connection_string
  https_only        = true
  signed_version    = "2022-11-02"
  start             = time_static.now.rfc3339
  expiry            = timeadd(time_static.now.rfc3339, "24h")

  resource_types {
    service   = false
    container = false
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}

# Create Azure Public IP for Load Balancer
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Load Balancer
resource "azurerm_lb" "load_balancer" {
  name                = var.load_balancer_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Load Balancer Backend Address Pool
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = var.backend_pool_name
  loadbalancer_id = azurerm_lb.load_balancer.id
}

# Create Load Balancer Health Probe
resource "azurerm_lb_probe" "health_probe" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = var.health_probe_name
  protocol        = "Tcp"
  port            = 80
}

# Create Load Balancer Rule
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = var.load_balancing_rule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.health_probe.id
}

# Create Azure Network Interface for VM1
resource "azurerm_network_interface" "network_interface_1" {
  name                = var.network_interface_name_1
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = var.ip_configuration_name_1
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Network Interface for VM2
resource "azurerm_network_interface" "network_interface_2" {
  name                = var.network_interface_name_2
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = var.ip_configuration_name_2
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Associate VM1 Network Interface with Load Balancer Backend Pool
resource "azurerm_network_interface_backend_address_pool_association" "nic_1_backend_pool_assoc" {
  network_interface_id    = azurerm_network_interface.network_interface_1.id
  ip_configuration_name   = var.ip_configuration_name_1
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

# Associate VM2 Network Interface with Load Balancer Backend Pool
resource "azurerm_network_interface_backend_address_pool_association" "nic_2_backend_pool_assoc" {
  network_interface_id    = azurerm_network_interface.network_interface_2.id
  ip_configuration_name   = var.ip_configuration_name_2
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

# Create Azure Windows Virtual Machine 1
resource "azurerm_windows_virtual_machine" "virtual_machine_1" {
  name                  = var.windows_vm_name_1
  resource_group_name   = azurerm_resource_group.resource_group.name
  location              = var.location
  size                  = "Standard_D2s_v3"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.network_interface_1.id]

  os_disk {
    name                 = var.os_disk_name_1
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Windows Virtual Machine 2
resource "azurerm_windows_virtual_machine" "virtual_machine_2" {
  name                  = var.windows_vm_name_2
  resource_group_name   = azurerm_resource_group.resource_group.name
  location              = var.location
  size                  = "Standard_D2s_v3"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.network_interface_2.id]

  os_disk {
    name                 = var.os_disk_name_2
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Install IIS on VM1 using Custom Script Extension
resource "azurerm_virtual_machine_extension" "vm_extension_1" {
  name                 = var.vm_extension_name_1
  virtual_machine_id   = azurerm_windows_virtual_machine.virtual_machine_1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    fileUris = [
      "${azurerm_storage_blob.iis_script.url}${data.azurerm_storage_account_sas.storage_sas.sas}"
    ],
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -File IIS_Config.ps1"
  })
}

# Install IIS on VM2 using Custom Script Extension
resource "azurerm_virtual_machine_extension" "vm_extension_2" {
  name                 = var.vm_extension_name_2
  virtual_machine_id   = azurerm_windows_virtual_machine.virtual_machine_2.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    fileUris = [
      "${azurerm_storage_blob.iis_script.url}${data.azurerm_storage_account_sas.storage_sas.sas}"
    ],
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -File IIS_Config.ps1"
  })
}
