# 01 - Storage Account

## Objective

Create an **Azure Storage Account** using Terraform and understand how Terraform creates an **implicit dependency** between resources.

This folder continues the manual Service Principal authentication method introduced in folder `00-resource-group`.

## Authentication Note

The provider block uses placeholder values to show the Service Principal authentication fields.

Real credentials should not be committed to GitHub. Later folders in this repository use Azure CLI authentication with `az login`.

## Prerequisites

- An active Azure Subscription
- Terraform installed
- Create an **App Registration** in Microsoft Entra ID (formerly Azure Active Directory).
- Note the following values from the Azure portal:
  - `client_id` — Application (client) ID
  - `client_secret` — Client secret generated under **Certificates & Secrets**
  - `tenant_id` — Directory (tenant) ID
  - `subscription_id` — Your Azure subscription ID
- Assign the app registration the Contributor role for the subscription or resource group where the resources will be deployed

## How It Works

1. A Resource Group is created.
2. A Storage Account is created inside the Resource Group.
3. Terraform automatically understands the dependency because the Storage Account references the Resource Group name:

```hcl
resource_group_name = azurerm_resource_group.resource_group.name
```

Note: Azure Storage Account names must be globally unique. This configuration uses a random suffix to reduce the chance of name conflicts.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan
```

To deploy the storage account:

```bash
terraform apply
```

To remove all resources created by this folder:

```bash
terraform destroy
```
