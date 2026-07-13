# 19 - Azure DNS Zone

## Objective

Deploy a standalone DNS-integrated public web endpoint using Azure DNS, Azure Load Balancer, and private backend Windows Virtual Machines.

This lab demonstrates how a DNS record can point to a public Load Balancer endpoint that routes HTTP traffic to private backend servers.

This setup includes:

- Resource Group
- Virtual Network
- Subnet
- Network Security Group with inbound HTTP access
- Availability Set for backend virtual machines
- Public IP for the Load Balancer
- Azure Load Balancer
- Frontend IP configuration
- Backend address pool
- Health probe
- Load balancing rule for HTTP traffic on port 80
- Two Network Interfaces
- Two Windows Virtual Machines without public IP addresses
- Custom Script Extensions to install IIS on both VMs
- Azure DNS Zone
- DNS A record pointing to the Load Balancer public IP

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
- Local terraform.tfvars file created from terraform.tfvars.example
- A domain name if you want to test real DNS resolution

## Configuration Files

- variables.tf — defines input variables
- outputs.tf — displays the Load Balancer public IP, DNS name servers, and A record FQDN
- terraform.tfvars.example — safe sample variable file
- terraform.tfvars — local values file, excluded from GitHub

## How It Works

1. Terraform creates a Resource Group.
2. Terraform creates a Virtual Network and subnet.
3. Terraform creates a Network Security Group for HTTP traffic.
4. Terraform creates an Availability Set for the backend virtual machines.
5. Terraform creates a Standard Public IP for the Load Balancer.
6. Terraform creates an Azure Load Balancer with a frontend IP configuration.
7. Terraform creates a backend address pool, health probe, and HTTP load balancing rule.
8. Terraform creates two Network Interfaces and associates them with the backend pool.
9. Terraform creates two Windows Virtual Machines without public IP addresses.
10. Terraform installs IIS on both VMs using Custom Script Extensions.
11. Terraform creates an Azure DNS Zone.
12. Terraform creates an A record that points to the Load Balancer public IP.
13. HTTP traffic sent to the DNS record is routed through the Load Balancer to one of the backend VMs.

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

View the outputs:

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
2. Virtual Network and subnet
3. Network Security Group
4. Availability Set
5. Public IP address
6. Load Balancer
7. Backend address pool
8. Health probe
9. Load balancing rule
10. Network Interfaces
11. Windows Virtual Machines
12. Custom Script Extensions
13. DNS Zone
14. DNS A record

To test the Load Balancer directly:

```bash
terraform output load_balancer_public_ip
```

Open the Load Balancer public IP in a browser using HTTP, or test it from the terminal:

```bash
curl http://<load-balancer-public-ip>
```

Expected response:

```text
This is the server vm-aztf-19-win1!
```

or:

```text
This is the server vm-aztf-19-win2!
```

To test DNS resolution:

```bash
terraform output dns_record_fqdn
dig +short <dns-record-fqdn>
```

The DNS record should resolve to the Load Balancer public IP.

To test the DNS record over HTTP:

```bash
curl http://<dns-record-fqdn>
```

Expected response:

```text
This is the server vm-aztf-19-win1!
```

or:

```text
This is the server vm-aztf-19-win2!
```

Some browsers may automatically upgrade HTTP to HTTPS for certain domains. This lab configures HTTP only on port 80. If the browser switches to HTTPS, validate the deployment using `curl`.

## Security Notes

- Backend virtual machines are not assigned public IP addresses.
- The Load Balancer is the only public entry point for HTTP traffic.
- The DNS A record points to the Load Balancer public IP.
- The admin password is kept only in the local terraform.tfvars file, which is excluded from GitHub.
