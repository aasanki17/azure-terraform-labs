# 02 - Container and Blob

## Objective

Create an Azure Storage Container and upload a Blob using Terraform.

This folder demonstrates explicit and implicit dependencies between Azure resources while continuing the manual Service Principal authentication method from the earlier folders.

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

## Authentication Note

The provider block uses placeholder values to show the Service Principal authentication fields.

Real credentials should not be committed to GitHub. Later folders in this repository use Azure CLI authentication with `az login`.

## How It Works

1. A Resource Group is created.
2. A Storage Account is created inside the Resource Group.
3. A private Storage Container is created inside the Storage Account.
4. A Blob is uploaded to the Storage Container.

Terraform uses resource references to understand dependencies between these resources. This folder also includes an explicit `depends_on` example to show how dependency ordering can be controlled.

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

To create a Storage Container and upload the Blob:

```bash
terraform apply
```

The uploaded Blob is:

`sample-main.tf`

To remove all resources created by this folder:

```bash
terraform destroy
```
