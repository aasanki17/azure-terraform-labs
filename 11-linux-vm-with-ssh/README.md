# 11 - Azure Linux Virtual Machine with SSH Key Authentication

## Objective

Deploy an **Azure Linux Virtual Machine** using Terraform with SSH key-based authentication.

This module creates the networking components required for the Linux VM and configures an inbound SSH rule so the VM can be accessed securely using an SSH private key.

This setup includes:

- Resource Group
- Virtual Network
- Subnet
- Public IP
- Network Interface
- Network Security Group
- NSG to Subnet Association
- Linux Virtual Machine

It uses SSH key-based authentication for Linux VM login. The public key is read from a local file and added to the VM during provisioning. The private key remains on your local machine and is not committed to GitHub.

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
- A valid SSH key pair
- A local `terraform.tfvars` file created from `terraform.tfvars.example`

## SSH Key Setup

SSH key authentication uses a key pair:

- The public key is used by Azure to configure VM access
- The private key stays securely on your local machine

Generate an SSH key pair:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/aztf-11-linux
```

When prompted for a passphrase, press Enter twice to leave it empty for this lab.

This creates:

- Private key: `~/.ssh/aztf-11-linux`
- Public key: `~/.ssh/aztf-11-linux.pub`

Check that both files were created:

```bash
ls -l ~/.ssh/aztf-11-linux*
```

You should see both key files:

- `aztf-11-linux`
- `aztf-11-linux.pub`

Secure the private key permissions:

```bash
chmod 600 ~/.ssh/aztf-11-linux
```

Use the public key path in your local `terraform.tfvars` file:

```hcl
public_ssh_key_path = "~/.ssh/aztf-11-linux.pub"
```

## Configuration Files

This folder uses separate Terraform files to keep the configuration organized:

- `variables.tf` — defines the input variables used by the configuration
- `terraform.tfvars.example` — provides a safe template for required variable values
- `terraform.tfvars` — stores local values used during deployment and is excluded from GitHub

Create a local `terraform.tfvars` file from `terraform.tfvars.example`, then update the SSH public key path if needed.

The actual `terraform.tfvars` file is not committed because it can contain environment-specific values such as local SSH key paths.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

Deploy the Linux VM with SSH key-based authentication:

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

9. Connect from your terminal using the private key:

```bash
ssh -i ~/.ssh/aztf-11-linux aztfadmin@<PUBLIC_IP_ADDRESS>
```

10. After logging in, verify outbound internet access:

```bash
ping google.com
```

## Security Note

This lab uses SSH key-based authentication instead of password authentication. The private key remains on the local machine, while only the public key is passed to Azure during VM provisioning.
