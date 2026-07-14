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

# Create Azure Storage Account for IIS script
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

# Create private Blob Container
resource "azurerm_storage_container" "storage_container" {
  name                  = var.storage_container_name
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

# Upload IIS PowerShell script to Blob Storage
resource "azurerm_storage_blob" "storage_blob" {
  name                   = var.storage_blob_name
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.storage_container.name
  type                   = "Block"
  source                 = "${path.module}/IIS_Config.ps1"
}

# Generate SAS token for the IIS script
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

# Create Standard Public IP for Load Balancer
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

# Create Standard Load Balancer
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

# Create Load Balancer Rule for HTTP traffic
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = var.load_balancing_rule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.health_probe.id
  disable_outbound_snat          = true
}

# Create Load Balancer Outbound Rule for VMSS internet access
resource "azurerm_lb_outbound_rule" "outbound_rule" {
  name                    = var.outbound_rule_name
  loadbalancer_id         = azurerm_lb.load_balancer.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id

  frontend_ip_configuration {
    name = var.frontend_ip_configuration_name
  }
}

# Create Azure Windows Virtual Machine Scale Set
resource "azurerm_windows_virtual_machine_scale_set" "vm_scale_set" {
  name                = var.vmss_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  sku                 = "Standard_D2s_v3"
  instances           = 2
  upgrade_mode        = "Automatic"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = var.vmss_network_interface_name
    primary = true

    ip_configuration {
      name      = var.vmss_ip_configuration_name
      primary   = true
      subnet_id = azurerm_subnet.subnet.id

      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.backend_pool.id
      ]
    }
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Install IIS on VMSS instances using Custom Script Extension
resource "azurerm_virtual_machine_scale_set_extension" "vmss_extension" {
  name                         = var.vmss_extension_name
  virtual_machine_scale_set_id = azurerm_windows_virtual_machine_scale_set.vm_scale_set.id
  publisher                    = "Microsoft.Compute"
  type                         = "CustomScriptExtension"
  type_handler_version         = "1.10"

  settings = jsonencode({
    fileUris = [
      "${azurerm_storage_blob.storage_blob.url}${data.azurerm_storage_account_sas.storage_sas.sas}"
    ],
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -File IIS_Config.ps1"
  })

  depends_on = [
    azurerm_lb_outbound_rule.outbound_rule
  ]
}

# Create Azure Monitor Autoscale Setting for VMSS
resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {
  name                = var.autoscale_setting_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  target_resource_id  = azurerm_windows_virtual_machine_scale_set.vm_scale_set.id
  enabled             = true

  profile {
    name = "cpu-autoscale-profile"

    capacity {
      default = 2
      minimum = 1
      maximum = 4
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.vm_scale_set.id
        metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.vm_scale_set.id
        metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}
