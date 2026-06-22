# 03 - Virtual Network with Subnets

## Objective

Create an **Azure Virtual Network** with two **subnets** using Terraform.

This folder introduces **Terraform variables and locals** while continuing the manual Service Principal authentication method from the earlier folders.

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
- Assign the app registration the **Contributor** role for the subscription or resource group where the resources will be deployed

## How It Works

1. A Resource Group is created.
2. A Virtual Network is created inside the Resource Group.
3. Two subnets are defined inside the Virtual Network.
4. Terraform variables define the Resource Group and Virtual Network names. Default values are provided, but the Virtual Network name can also be overridden from the command line using `-var`.
5. A local value is used for the Azure region.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan
```

To create the Azure Virtual Network with two subnets:

```bash
terraform apply
```

Optional: to override the default Virtual Network name, use:

```bash
terraform apply -var "virtual_network_name=vnet-aztf-03-custom"
```

To remove all resources created by this folder:

```bash
terraform destroy
```
