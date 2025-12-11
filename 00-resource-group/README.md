# 00 - Resource group

## Objective

Create an Azure Resource Group using Terraform while learning how to authenticate with Azure using a **Service Principal (App Registration)**.

This folder demonstrates the _manual authentication method_.

## Prerequisites

- An active Azure Subscription
- Terraform installed
- Create an **App Registration** in Microsoft Entra ID (formerly Azure Active Directory).
- Note down the following values from the Azure portal:
  - `client_id` — Application (client) ID
  - `client_secret` - Client secret generated under **Certificates & Secrets**
  - `tenant_id` — Directory (tenant) ID
  - `subscription_id` — Your Azure subscription ID
- Assign the app registration the **Contributor** role for the subscription or resource group where I plan to deploy the resources.

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
