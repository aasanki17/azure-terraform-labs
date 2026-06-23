# 15 - Azure SQL Database

## Objective

Provision a **fully managed Azure SQL Database** using Terraform and configure a SQL Server firewall rule for controlled client access.

This module demonstrates deployment of a Platform-as-a-Service (PaaS) relational database in Azure without managing virtual machines.

This setup includes:

- Resource Group
- Azure SQL Server
- Azure SQL Database
- SQL Server firewall rule for client IP access

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
- Your current public IP address for SQL firewall access

## Firewall Configuration

Azure SQL Server blocks external connections by default.

This lab creates a firewall rule that allows access only from the client IP address provided in:

```hcl
allowed_client_ip = "x.x.x.x"
```

Use your current public IP address for this value.

You can find your public IP address by running:

```bash
curl ifconfig.me
```

## Configuration Files

This folder uses separate Terraform files to keep the configuration organized:

- `variables.tf` — defines the input variables used by the configuration
- `terraform.tfvars.example` — provides a safe template for required variable values
- `terraform.tfvars` — stores local values used during deployment and is excluded from GitHub

Create a local `terraform.tfvars` file from `terraform.tfvars.example`, then update the SQL administrator password and allowed client IP address.

The actual `terraform.tfvars` file is not committed because it contains sensitive values such as the SQL administrator password and environment-specific values such as your public IP address.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

Deploy the Azure SQL Server, SQL Database, and firewall rule:

```bash
terraform apply -var-file="terraform.tfvars"
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Validation

After deployment, verify the following in the Azure Portal:

1. Open the Resource Group created by this lab.

2. Confirm that the following resources exist:
   - Azure SQL Server
   - Azure SQL Database

3. Open the Azure SQL Server.

4. Go to:

```text
Networking → Firewall rules
```

5. Confirm that the firewall rule exists:
   - `allow-client-ip`

6. Confirm that the firewall rule uses your public IP address.

7. Open the Azure SQL Database.

8. Confirm:
   - Status: Online
   - Pricing tier / SKU: Basic
   - Server is linked correctly

9. Test database connectivity using Visual Studio Code with the MSSQL extension or another SQL client.

Connection format:

```text
<sql-server-name>.database.windows.net
```

Use:

- Authentication: SQL Login
- Username: value of `mssql_admin_username`
- Password: value of `mssql_admin_password`
- Database: value of `mssql_database_name`
