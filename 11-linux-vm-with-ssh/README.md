# 11 - Azure Linux VM with SSH Authentication

## Objective

Use Terraform to provision a **Linux Virtual Machine** in Azure using **SSH authentication**, along with the required networking components:

- Virtual Network
- Subnet
- Network Interface (NIC)
- Public IP
- Network Security Group (NSG)

SSH authentication enhances security by ensuring that only clients with a valid private key can access the VM. It uses dynamic input via `variables.tf` and secure authentication via `az login`.

## Prerequisites

- An active Azure Subscription
- Azure CLI installed and authenticated (`az login`)
- Terraform installed
- A valid SSH key pair (e.g., `~/.ssh/terraformvm_key.pub`)
- An optional `terraform.tfvars` file (excluded via `.gitignore`) for custom values

## Azure Authentication (az login)

Instead of hardcoding sensitive credentials (`client_id`, `client_secret`, etc.), this project uses the Azure CLI session:

```bash
az login
```

This allows Terraform to authenticate securely without passing client_id, client_secret, or tenant_id.

## SSH Key Overview

SSH (Secure Shell) allows you to securely connect to your Linux VM without using a password. It works using a key pair:

- The **public key** is provisioned to the VM using Terraform
- The **private key**y stays securely on your local machine. Never share your private key.

You can generate an SSH key pair using the command below:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/<file_name>
```

Verify the keys:

```bash
ls -l ~/.ssh/<file_name>*
```

you should see something like:

-rw------- <file_name> (A **private key** at: ~/.ssh/id_rsa)
-rw-r--r-- <file_name>.pub (A **public key** at: ~/.ssh/id_rsa.pub)

Secure the private key permissions:

```bash
chmod 600 ~/.ssh/<file_name>
```

This method improves security and follows Azure best practices. To connect into the VM:

```bash
ssh -i ~/.ssh/<file_name> <admin_username>@<PUBLIC_IP>
```

Your SSH client automatically uses the private key stored in ~/.ssh/id_rsa. If the private key does not match the public key on the VM, login will fail with a “Permission denied (publickey)” error.

In Production:

- SSH keys are usually generated outside Terraform
- The public key path is referenced in `terraform.tfvars`
- The private key stays secure with the engineer or is managed via tools like Azure Key Vault or GitHub Secrets (CI/CD)

## Variable Configuration

This project uses two files to manage variables:

`variables.tf` — defines expected inputs
`terraform.tfvars` — supplies input values

Example terraform.tfvars:

```hcl
var_location             = "West Europe"
var_resource_group_name  = "terraformrg"
var_virtual_network_name = "terraformvn"
var_subnet_name          = "terraformsubnet"
var_public_ip_name       = "terraformpublicip"
var_nic_name             = "terraformnic"
var_nsg_name             = "terraformnsg"
var_linux_vm_name        = "terraformvm"
var_admin_username       = "adminuser"
var_public_ssh_key_path  = "~/.ssh/terraformvm_key.pub"
```

Terraform will automatically detect and use this file if it's named terraform.tfvars.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

To deploy the Linux VM with SSH authentication enabled:

```bash
terraform apply -var-file="terraform.tfvars"
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Validate the Deployment

Once deployed, copy the public IP from the Azure portal and SSH into the VM:

```bash
ssh -i ~/.ssh/<file_name> <admin_username>@<PUBLIC_IP>
```
