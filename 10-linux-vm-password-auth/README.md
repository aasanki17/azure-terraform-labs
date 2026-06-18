# 10 - Azure Linux Virtual Machine with Password Authentication

## Objective

Deploy an **Azure Linux Virtual Machine** using Terraform with password-based authentication.

This module creates the networking components required for the Linux VM and configures an inbound SSH rule so the VM can be accessed using SSH.

This setup includes:

- Resource Group
- Virtual Network
- Subnet
- Public IP
- Network Interface
- Network Security Group
- NSG to Subnet Association
- Linux Virtual Machine

It uses password-based authentication for Linux VM login. Configuration is clean and modular, using `variables.tf` for dynamic values and Azure CLI for authentication.

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

## Configuration Files

This folder uses separate Terraform files to keep the configuration organized:

- `variables.tf` — defines the input variables used by the configuration
- `terraform.tfvars.example` — provides a safe template for required variable values
- `terraform.tfvars` — stores local values used during deployment and is excluded from GitHub

Create a local `terraform.tfvars` file from `terraform.tfvars.example`, then replace `admin_password` with a strong password that meets Azure Linux VM password requirements.

The actual `terraform.tfvars` file is not committed because it can contain sensitive values such as the VM administrator password.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

Deploy the Linux VM with password-based authentication:

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
   - Virtual Network
   - Subnet
   - Public IP
   - Network Interface
   - Network Security Group
   - Linux Virtual Machine

3. Open the Network Security Group.

4. Go to:
   - Inbound security rules

5. Confirm that the SSH rule exists:
   - allow-ssh

6. Confirm that the rule allows:
   - Protocol: TCP
   - Port: 22
   - Direction: Inbound
   - Access: Allow

7. Open the Linux Virtual Machine and confirm that it is running.

8. Copy the Public IP address.

9. Connect from your terminal:

```bash
ssh aztfadmin@<PUBLIC_IP_ADDRESS>
```

10. After logging in, verify outbound internet access:

```bash
ping google.com
```

## Security Note

This lab uses password-based SSH authentication for learning purposes. Password authentication is less secure than SSH key-based authentication and should not be preferred for production environments.

The NSG rule allows SSH traffic on port 22. For a production setup, SSH access should be restricted to a trusted source IP address instead of being open broadly.

This module demonstrates basic Linux VM deployment and password-based SSH access using Terraform.
