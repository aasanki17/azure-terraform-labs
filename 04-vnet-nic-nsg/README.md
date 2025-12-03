# 04 - Azure VNet, Subnet, NIC, Public IP and NSG

## Objective

Use Terraform to create all required networking components:

- Virtual Network
- Subnet
- Network Interface (NIC)
- Public IP Address
- Network Security Group (NSG)
- NSG-to-Subnet Association

The configuration is modular and clean, using only `variables.tf` for dynamic values. The Azure provider uses Azure CLI login (az login) for authentication, making it more secure and CI/CD friendly.

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

`variables.tf` — defines the expected input variables
`terraform.tfvars` — provides values for those inputs

Example terraform.tfvars:

```hcl
var_location             = "West Europe"
var_resource_group_name  = "terraformrg"
var_virtual_network_name = "terraformvn"
var_subnet_name          = "terraformsubnet"
var_public_ip_name       = "terraformpublicip"
var_nic_name             = "terraformnic"
var_nsg_name             = "terraformnsg"
```

Terraform will automatically detect and use this file if it's named terraform.tfvars.

## - Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

To create an Azure Virtual Network with two subnets:

```bash
terraform apply -var-file="terraform.tfvars"
```

To remove all resources created by this folder:

```bash
terraform destroy -var-file="terraform.tfvars"
```
