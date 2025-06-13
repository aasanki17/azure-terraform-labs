# 00 - Resource group

## Objective

Use Terraform to create an Azure Resource Group in Microsoft Azure by manually configuring the Azure provider with authentication values.

## Prerequisites

- Create an **App Registration** in Microsoft Entra ID (formerly Azure Active Directory).
- Note down the following values from the Azure portal:
  - `client_id`
  - `client_secret` (Generate under "Certificates & Secrets")
  - `tenant_id`
  - `subscription_id` (from my Azure Subscription)
- Assign the app registration the **Contributor** role for the subscription or resource group where I plan to deploy the resources.

## Steps Performed

To deploy the resource group:

```bash
terraform init
terraform plan
terraform apply
```

To destroy the resource group:

```bash
terraform destroy
```