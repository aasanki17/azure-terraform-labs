# 05 - Azure Windows Virtual Machine

## Objective

Create an **Azure Windows Virtual Machine** using Terraform, along with the required networking components: Virtual Network, Subnet, Public IP, and Network Interface.

This folder builds on the networking foundation from `04-vnet-nic-nsg` and introduces Windows VM provisioning with sensitive input variables for administrator credentials.

## Prerequisites

- An active Azure Subscription
- Azure CLI installed and authenticated (`az login`)
- Terraform installed
- A local `terraform.tfvars` file created from `terraform.tfvars.example`

## Azure Authentication (az login)

Instead of hardcoding sensitive credentials (`client_id`, `client_secret`, etc.), this project uses the Azure CLI session:

```bash
az login
```

This allows Terraform to authenticate securely without passing `client_id`, `client_secret`, or `tenant_id` in the provider block.

## Configuration Files

This folder uses separate Terraform files to keep the configuration organized:

- `variables.tf` — defines the input variables used by the configuration
- `terraform.tfvars.example` — provides a safe template for required variable values
- `terraform.tfvars` — stores local values used during deployment and is excluded from GitHub

Create a local `terraform.tfvars` file from `terraform.tfvars.example`, then replace `admin_password` with a strong password that meets Azure VM password requirements.

The actual `terraform.tfvars` file is not committed because it can contain sensitive values such as the VM administrator password.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

Deploy the Windows VM and networking components:

```bash
terraform apply -var-file="terraform.tfvars"
```

Destroy all created resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```
