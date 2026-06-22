# 04 - VNet, NIC, Public IP, and NSG

## Objective

Create core **Azure networking components** using Terraform, including a Virtual Network, Subnet, Public IP, Network Interface, Network Security Group, and NSG-to-Subnet association.

This folder introduces a more structured Terraform workflow using separate configuration files, Azure CLI authentication with `az login`, and a Network Security Group rule that restricts RDP access to a configured admin IP range.

## Azure Authentication (az login)

Instead of hardcoding sensitive credentials (`client_id`, `client_secret`, etc.), this project uses the Azure CLI session:

```bash
az login
```

This allows Terraform to authenticate securely without passing `client_id`, `client_secret`, or `tenant_id` in the provider block.

## Prerequisites

- An active Azure Subscription
- Azure CLI installed and authenticated (`az login`)
- Terraform installed
- A local `terraform.tfvars` file created from `terraform.tfvars.example`

## Configuration Files

This folder uses separate Terraform files to keep the configuration organized:

- `variables.tf` — defines the input variables used by the configuration
- `terraform.tfvars.example` — provides a safe template for required variable values
- `terraform.tfvars` — stores local values used during deployment and is excluded from GitHub
- `outputs.tf` — displays useful values after deployment, such as the Public IP address and Network Security Group name

Create a local `terraform.tfvars` file from `terraform.tfvars.example`, then replace `allowed_admin_cidr` with your own public IP in CIDR format, for example `x.x.x.x/32`.

The actual `terraform.tfvars` file is not committed because it can contain personal values such as your public IP address.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

To create the networking resources:

```bash
terraform apply -var-file="terraform.tfvars"
```

After deployment, Terraform displays the Public IP address and Network Security Group name from `outputs.tf`.

To remove all resources created by this folder:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Security Note

This lab uses a Network Security Group to control inbound access. Instead of allowing all inbound traffic, the rule allows RDP only from a configured admin IP range.
