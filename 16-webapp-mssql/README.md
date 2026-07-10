# 16 - Azure Web App with SQL Database and Blob-Based SQL Script

## Objective

Deploy an Azure Windows Web App connected to an Azure SQL Database, upload a SQL seed script to Azure Blob Storage, and initialize the database using Terraform with local sqlcmd execution.

This module demonstrates how Azure App Service, Azure SQL Database, Azure Storage, Blob upload, SQL firewall rules, and GitHub-based deployment can be connected using Terraform.

This setup includes:

- Resource Group
- Azure Storage Account
- Azure Storage Container
- SQL script uploaded as a Blob
- Read-only SAS token for the SQL script
- Azure SQL Server
- Azure SQL Database
- SQL Server firewall rule for client IP access
- Azure App Service Plan
- Azure Windows Web App
- Web App SQL connection string
- Database initialization using sqlcmd during terraform apply
- GitHub-based source control deployment

## Azure Authentication

This project uses Azure CLI authentication:

```bash
az login
```

Terraform uses the active Azure CLI session, so no Azure client secret is stored in the Terraform files.

## Prerequisites

- Active Azure subscription
- Azure CLI installed and authenticated
- Terraform installed
- sqlcmd installed locally
- GitHub repository for Web App deployment
- GitHub Personal Access Token
- Current public IP address for SQL firewall access
- Local terraform.tfvars file created from terraform.tfvars.example

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

- variables.tf — defines input variables
- outputs.tf — displays useful deployment values
- terraform.tfvars.example — safe sample variable file
- terraform.tfvars — local values file, excluded from GitHub
- load-data.sql — creates and populates the sample SQL table

## How It Works

1. Terraform creates a Resource Group.
2. Terraform creates a Storage Account and private Storage Container.
3. Terraform uploads load-data.sql to the private container.
4. Terraform generates a temporary read-only SAS token for the SQL script.
5. Terraform creates an Azure SQL Server and Azure SQL Database.
6. Terraform creates a SQL firewall rule for the configured client IP.
7. Terraform runs load-data.sql locally using sqlcmd to create and populate the Inventory table.
8. Terraform creates a Windows App Service Plan and Windows Web App.
9. Terraform adds a SQL connection string to the Web App.
10. Terraform connects the Web App to the GitHub repository.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview the deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

Deploy the resources:

```bash
terraform apply -var-file="terraform.tfvars"
```

View outputs:

```bash
terraform output
```

Destroy the resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Validation

After deployment, check these resources in Azure Portal:

1. Resource Group
2. Storage Account
3. Storage Container
4. Uploaded load-data.sql Blob
5. Azure SQL Server
6. Azure SQL Database
7. SQL firewall rule named allow-client-ip
8. App Service Plan
9. Windows Web App
10. Web App SQL connection string
11. Deployment Center connected to GitHub

The Web App should contain the SQL connection string:

```text
SqlDatabase
```

Check the database using VS Code with the MSSQL extension or sqlcmd:

```sql
SELECT *
FROM dbo.Inventory;
```

Expected rows:

```text
ProductID  ProductName  Quantity
1          Mobile       100
2          Laptop       200
3          Headphones   300
```

You can also validate from the terminal using sqlcmd:

```bash
sqlcmd \
  -S "$(terraform output -raw sql_server_fqdn)" \
  -d "sqldb-aztf-16" \
  -U "aztfadmin" \
  -P "$(grep mssql_admin_password terraform.tfvars | cut -d'"' -f2)" \
  -Q "SELECT * FROM dbo.Inventory;" \
  -C
```
