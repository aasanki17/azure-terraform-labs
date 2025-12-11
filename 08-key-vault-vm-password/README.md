# 08 - Azure Key Vault: Store VM Admin Password

## Objective

Use Terraform to create a **Windows Virtual Machine** in Azure and securely manage the **admin password** using **Azure Key Vault**. Instead of directly passing the password to the VM, it is stored as a **Key Vault Secret**, and the VM retrieves it at provisioning time.

This setup includes:

- Secure password management using Azure Key Vault
- Full network infrastructure (VNet, Subnet, Public IP, NIC)
- Optional random suffix for Key Vault name (for global uniqueness)

## Prerequisites

- An active Azure Subscription
- Azure CLI installed and authenticated (`az login`)
- Terraform installed
- An optional `terraform.tfvars` file (excluded via `.gitignore`) for custom values

## Azure Authentication (az login)

Instead of hardcoding sensitive credentials (`client_id`, `client_secret`, etc.), this project uses the Azure CLI session:

```bash
az login
```

This allows Terraform to authenticate securely without passing client_id, client_secret, or tenant_id.

## Variable Configuration

This project uses two files to manage variables:

`variables.tf` — defines expected inputs
`terraform.tfvars` — supplies input values

Example terraform.tfvars:

```hcl
var_location             = "West Europe"
var_resource_group_name  = "terraformrg"
var_virtual_network_name = "terraformvn"
var_subnet_name          = "terraformsubnet"
var_public_ip_name       = "terraformpublicip"
var_nic_name             = "terraformnic"
var_key_vault_name       = "terraformkv"
var_windows_vm_name      = "terraformvm"
var_admin_username       = "adminuser"
var_admin_password       = "AzureVMpwd@123"
```

Terraform will automatically detect and use this file if it's named terraform.tfvars.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

To provision a Windows VM and securely store its admin password in Azure Key Vault:

```bash
terraform apply -var-file="terraform.tfvars"
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```
