# 08 - Store VM Admin Password in Azure Key Vault

## Objective

Deploy an Azure Windows Virtual Machine using Terraform and store the VM administrator password securely in Azure Key Vault.

This folder builds on the Windows VM deployment from earlier modules and introduces secure secret management using Azure Key Vault. Instead of hardcoding the VM administrator password directly in the Terraform configuration, the password is provided through a local `terraform.tfvars` file, stored as a Key Vault secret, and then used during VM provisioning.

This setup includes:

- Virtual Network
- Subnet
- Public IP
- Network Interface
- Key Vault
- Key Vault Secret
- Windows Virtual Machine

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
- `outputs.tf` — displays the Key Vault name and Key Vault secret name

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

Deploy the Windows VM and store the admin password in Azure Key Vault:

```bash
terraform apply -var-file="terraform.tfvars"
```

After deployment, view the outputs:

```bash
terraform output
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Validation

After deployment, verify the following in the Azure Portal:

1. Open the Resource Group created by this lab.

2. Confirm that the following resources exist:
   - Key Vault
   - Public IP
   - Network Interface
   - Virtual Network
   - Windows Virtual Machine

3. Open the Key Vault.

4. Go to:
   Objects → Secrets

5. Confirm that the VM admin password secret exists:
   kv-secret-aztf-08

6. Open the Windows Virtual Machine and confirm that it was created successfully.

7. View the Terraform outputs:

```bash
terraform output
```

8. Confirm that the output includes:
   - Key Vault name
   - Key Vault secret name

## Security Note

The VM administrator password is still supplied locally through `terraform.tfvars`, but the file is excluded from GitHub. Terraform stores that value as a secret in Azure Key Vault and uses the Key Vault secret value during VM provisioning.

This module demonstrates how Azure Key Vault can be used to centralize and manage sensitive values instead of hardcoding them directly in Terraform resource blocks.
