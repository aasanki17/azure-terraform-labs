# 12 - Azure Linux VM with cloud-init (NGINX Installation)

## Objective

Provision a **Linux Virtual Machine** in Azure using Terraform and configure it with **cloud-init** to automatically install **NGINX** upon deployment. This setup includes all required networking components:

- Virtual Network
- Subnet
- Network Interface (NIC)
- Public IP Address
- Network Security Group (SSH + HTTP)
- Linux VM bootstrapped using **cloud-init**
- Automatic installation of **NGINX**

This approach showcases **Infrastructure as Code (IaC)** with **automatic provisioning and configuration** of services on first boot.

## Prerequisites

- An active Azure Subscription
- Azure CLI installed and authenticated (`az login`)
- Terraform installed
- A valid SSH key pair (default path: `~/.ssh/id_rsa.pub`)
- An optional `terraform.tfvars` file (excluded via `.gitignore`) for custom values

## What is cloud-init?

`cloud-init` is a widely supported mechanism to initialize cloud instances at **first boot**. It allows automation of:

- Package installations (like `nginx`, `curl`)
- User setup
- Hostname configuration
- Custom startup commands (`runcmd`)

In this project, we use `cloud-init` to install and start **NGINX** on the VM during provisioning.

### cloud-init YAML Configuration

The actual cloud-init configuration is stored in a separate file: `cloud-init.yaml`.

```yaml
#cloud-config
package_update: true
package_upgrade: true

packages:
  - nginx

runcmd:
  - systemctl enable nginx
  - systemctl start nginx
```

Terraform reads this file with templatefile(...) and passes it to the VM via the custom_data field, base64-encoded.

## Azure Authentication (az login)

Instead of hardcoding sensitive credentials (`client_id`, `client_secret`, etc.), this project uses the Azure CLI session:

```bash
az login
```

This allows Terraform to authenticate securely without passing client_id, client_secret, or tenant_id.

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

To deploy the Linux VM with NGINX installed via cloud-init:

```bash
terraform apply -var-file="terraform.tfvars"
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Validate the Deployment

1. In the Azure Portal, go to Resource groups → your resource group → terraformvm (or your VM name) and confirm the VM is running.

2. From the portal, copy the Public IP address of the VM.

3. From your Mac terminal, SSH into the VM:

```bash
ssh -i ~/.ssh/<file_name> <admin_username>@<PUBLIC_IP>
```

4. Validate that NGINX is running:

```bash
curl http://<PUBLIC_IP>
```

or

```bash
nginx -v
```

or

```bash
systemctl status nginx
```

You should see the default NGINX welcome page HTML.
