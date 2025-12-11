# 02 - Container and Blob

## Objective

Use Terraform to create a Storage Container and upload a Blob with explicit and implicit dependency in Microsoft Azure by manually configuring the Azure provider with authentication values.

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

To create a Storage Container and upload a Blob:

```bash
terraform apply
```

Blob uploaded:

`terraformcontainerblob2`

To remove all resources created by this folder:

```bash
terraform destroy
```
