# GitOps Kubernetes Platform

Production-style GitOps platform built with **Terraform, Kubernetes, Helm, Argo CD, nginx, GitHub Actions, and observability add-ons**.

This project is designed as a portfolio-ready DevOps project that demonstrates how to provision a Kubernetes environment as code, deploy applications using GitOps, and operate the platform with repeatable CI/CD workflows.

## Why this project matters

Most entry-level DevOps portfolios only show Docker or basic CI/CD. This project goes further by showing:

- Kubernetes platform provisioning with Terraform
- GitOps deployment using Argo CD
- Helm-based application packaging
- nginx Ingress routing
- GitHub Actions validation pipeline
- Environment-based folder structure
- Reproducible local cluster using kind
- Clean documentation suitable for recruiters and technical reviewers

## Architecture

```text
Developer Push
     |
     v
GitHub Repository
     |
     |-- GitHub Actions validates Terraform, Helm, YAML and Docker build
     |
     v
Argo CD watches Git repository
     |
     v
Kubernetes Cluster provisioned by Terraform
     |
     |-- nginx Ingress Controller
     |-- Portfolio API namespace
     |-- Helm-managed application release
     |-- Kubernetes services, deployments and config
```

## Tech Stack

| Area | Tools |
|---|---|
| Infrastructure as Code | Terraform |
| Container Orchestration | Kubernetes, kind |
| GitOps | Argo CD |
| Packaging | Helm |
| Routing | nginx Ingress Controller |
| CI/CD | GitHub Actions |
| App Runtime | Python FastAPI |
| Containers | Docker |

## Repository Structure

```text
.
├── apps/portfolio-api/          # FastAPI sample application
├── argocd/                      # Argo CD application definitions
├── helm/portfolio-api/          # Helm chart for the application
├── k8s/apps/                    # Optional raw Kubernetes examples
├── terraform/environments/dev/  # Terraform environment config
├── scripts/                     # Local setup and validation scripts
├── .github/workflows/           # CI validation pipeline
└── docs/                        # Architecture and screenshot notes
```

## Prerequisites

Install these tools locally:

- Docker Desktop
- Terraform
- kubectl
- Helm
- kind
- Git

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/gitops-kubernetes-platform.git
cd gitops-kubernetes-platform
```

### 2. Create the Kubernetes platform

```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply -auto-approve
```

Terraform will create:

- A local kind Kubernetes cluster
- nginx Ingress Controller
- Argo CD namespace
- Argo CD Helm release
- Application namespace

### 3. Access Argo CD

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open:

```text
https://localhost:8080
```

Get the default admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d && echo
```

Username:

```text
admin
```

### 4. Deploy the app through Argo CD

Update `argocd/portfolio-api-app.yaml` and replace the repo URL:

```yaml
repoURL: https://github.com/YOUR_USERNAME/gitops-kubernetes-platform.git
```

Then apply:

```bash
kubectl apply -f argocd/portfolio-api-app.yaml
```

### 5. Test the application

```bash
kubectl port-forward svc/portfolio-api -n portfolio-api 8000:80
curl http://localhost:8000/health
```

Expected response:

```json
{"status":"healthy","service":"portfolio-api"}
```

## CI/CD Pipeline

The GitHub Actions workflow validates:

- Terraform formatting
- Terraform init and validate
- Helm lint
- Kubernetes manifest rendering
- Docker image build

Workflow file:

```text
.github/workflows/platform-ci.yml
```

## Portfolio Talking Points

Use these points in interviews:

- Built a fully reproducible Kubernetes platform using Terraform.
- Used Argo CD to enforce Git as the single source of truth.
- Packaged application deployment with Helm for repeatable releases.
- Added nginx Ingress to simulate production traffic routing.
- Created CI checks to validate IaC and Kubernetes changes before deployment.
- Designed the repo with environment separation to mirror real platform engineering workflows.

## Resume Bullet

```text
Built a GitOps Kubernetes platform using Terraform, Argo CD, Helm and nginx, enabling reproducible cluster provisioning, automated app reconciliation from Git, and rollback-ready deployments with CI validation through GitHub Actions.
```

## Clean Up

```bash
cd terraform/environments/dev
terraform destroy -auto-approve
```

If Terraform cannot remove the kind cluster, run:

```bash
kind delete cluster --name gitops-dev
```
