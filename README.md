# DevOps Infrastructure & Automation Labs

A practical portfolio of hands-on DevOps, cloud infrastructure, automation, containerisation and systems engineering projects.

The repository documents working labs built to strengthen real-world infrastructure engineering skills across Linux, Windows, Azure, Infrastructure as Code, configuration management, Docker and Kubernetes. Each project contains its own documentation, configuration or source files, and practical examples.

## Projects

### Azure Terraform & Ansible Lab

Infrastructure-as-Code and configuration-management lab using Microsoft Azure, Terraform and Ansible.

Key areas covered:
- Azure resource provisioning with Terraform
- Resource groups, VNets, subnets, NSGs, public IPs and NICs
- Linux virtual machine deployment
- Terraform formatting, validation, planning and deployment
- Azure CLI authentication
- SSH-based remote administration
- Ansible inventory and playbooks
- Automated Nginx installation and configuration

[View project](./azure-terraform-ansible-lab)

### Docker + Kubernetes Microservices Lab

Containerisation and orchestration lab progressing from Docker containers to a frontend/backend Kubernetes microservices architecture.

Key areas covered:
- Docker image builds and container lifecycle management
- Docker networking and port publishing
- Docker Compose with Nginx and Redis
- Persistent Docker volumes
- Local Kubernetes cluster with kind
- Deployments, ReplicaSets and Pods
- Kubernetes Services and DNS-based service discovery
- Horizontal scaling and self-healing
- ConfigMaps
- Nginx reverse proxying
- Frontend/backend microservices communication
- `kubectl port-forward` for local testing

[View project](./docker-kubernetes-microservices-lab)

### Bash Linux Infrastructure Health Check

Linux infrastructure monitoring and automation using Bash scripting.

Key areas covered:
- Linux system health checks
- Service monitoring
- Disk and resource checks
- Network/connectivity validation
- Shell scripting and automation

[View project](./bash-linux-infrastructure-health-check)

### Python Infrastructure Health Check

Infrastructure health-check automation implemented in Python.

Key areas covered:
- System and resource monitoring
- Service and connectivity checks
- Structured health-check logic
- JSON-based output and infrastructure automation

[View project](./python-infrastructure-health-check)

### PowerShell Infrastructure Health Check

Windows-focused infrastructure health-check automation using PowerShell.

Key areas covered:
- Windows infrastructure administration
- Service and system checks
- PowerShell automation
- Operational troubleshooting and health reporting

[View project](./powershell-infrastructure-health-check)

### Network Inventory

Network infrastructure inventory work covering the documentation and organisation of network assets and infrastructure information.

[View project](./Network%20Inventory)

## Technologies

| Area | Technologies |
|---|---|
| Cloud | Microsoft Azure |
| Infrastructure as Code | Terraform |
| Configuration Management | Ansible |
| Containers | Docker, Docker Compose |
| Orchestration | Kubernetes, kind, kubectl |
| Web / Services | Nginx, Redis |
| Automation | Bash, Python, PowerShell |
| Operating Systems | Linux, Windows |
| Networking | TCP/IP, DNS, virtual networks, subnets, NSGs, container networking |
| Source Control | Git, GitHub |

## Architecture & Engineering Themes

The labs in this repository demonstrate several recurring infrastructure engineering principles:

- Infrastructure as Code rather than manual provisioning
- Repeatable configuration and automation
- Troubleshooting from symptoms through to root cause
- Service availability and infrastructure health monitoring
- Containerisation and workload isolation
- Service discovery and application networking
- Horizontal scaling and self-healing workloads
- Separation of application configuration from container images
- Version-controlled infrastructure and operational documentation

## Repository Structure

```text
DevOps/
├── Network Inventory/
├── azure-terraform-ansible-lab/
├── bash-linux-infrastructure-health-check/
├── docker-kubernetes-microservices-lab/
├── powershell-infrastructure-health-check/
├── python-infrastructure-health-check/
└── README.md
```

## About This Repository

This repository is continuously developed as additional infrastructure, cloud and DevOps labs are completed. The focus is on practical implementation: building environments, validating them, deliberately troubleshooting failures, documenting the architecture and retaining reproducible configuration in source control.
