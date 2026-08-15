# Azure Terraform + Ansible Lab

Hands-on Infrastructure-as-Code lab that provisions an Ubuntu web server in Microsoft Azure with Terraform and configures it with Ansible.

## Architecture

Terraform provisions:

- Azure Resource Group
- VNet (`10.10.0.0/16`)
- Application subnet (`10.10.1.0/24`)
- Network Security Group
- Static Public IP
- Network Interface
- NSG/NIC association
- Ubuntu 24.04 LTS VM

Ansible then connects to the VM over SSH and:

- Refreshes the apt package cache
- Installs Nginx
- Ensures Nginx is running and enabled
- Deploys a simple web page

## Terraform workflow

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

AzureRM 4.x requires the Azure subscription ID to be available to the provider. For an interactive lab using Azure CLI authentication, set `ARM_SUBSCRIPTION_ID` in the shell rather than committing subscription details to source control.

After deployment:

```bash
terraform output
```

## Ansible workflow

Copy the example inventory and replace the placeholder with the VM public IP:

```bash
cp ansible/inventory.ini.example ansible/inventory.ini
```

Test connectivity:

```bash
ansible all -i ansible/inventory.ini -m ping
```

Run the playbook:

```bash
ansible-playbook -i ansible/inventory.ini ansible/nginx.yml
```

Run the playbook a second time to observe Ansible idempotency: resources already in the desired state should report `ok` instead of being changed again.

## Security notes

This is an interview/training lab. The NSG allows SSH and HTTP from any source for accessibility during the exercise. A production design should restrict administrative access to trusted sources or use a controlled access service such as Azure Bastion.

Terraform state, local inventories, variable files and private SSH keys are excluded by `.gitignore` and must not be committed.

## Skills demonstrated

- Terraform HCL and AzureRM provider
- Terraform dependency graph and resource references
- `init`, `fmt`, `validate`, `plan`, `apply` workflow
- Azure networking and Linux VM provisioning
- SSH public-key authentication
- Ansible inventory and managed-node connectivity
- Ansible modules and playbooks
- Configuration management and idempotency
- Troubleshooting Azure authentication and SSH connectivity
