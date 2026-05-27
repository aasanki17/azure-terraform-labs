# 00 - Resource Group

## Objective

Create an Azure Resource Group using Terraform and understand how **Service Principal authentication** works in Azure.

This folder demonstrates manual Service Principal authentication using placeholder provider values.

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

## Authentication Note

The provider block uses placeholder values to show the Service Principal authentication fields.

Real credentials should not be committed to GitHub. Later folders in this repository use Azure CLI authentication with `az login`.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan
```

To deploy the resource group:

```bash
terraform apply
```

To remove all resources created by this folder:

```bash
terraform destroy
```
