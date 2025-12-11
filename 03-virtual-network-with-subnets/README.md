# 03 - Azure Virtual Network with Subnets

## Objective

Use Terraform to create an Azure Virtual Network with two subnets. This setup uses Terraform **variables** and **locals** for better flexibility, with the Azure provider manually configured.

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
terraform plan -var "var_virtual_network=terraformvn"
```

To create an Azure Virtual Network with two subnets:

```bash
terraform apply -var "var_virtual_network=terraformvn"
```

To remove all resources created by this folder:

```bash
terraform destroy -var "var_virtual_network=terraformvn"
```
