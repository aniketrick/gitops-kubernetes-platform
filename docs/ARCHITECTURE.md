# Architecture Notes

## Goal

Create a production-style Kubernetes delivery platform that shows cloud and DevOps fundamentals without requiring paid cloud resources.

## Design Decisions

### Terraform for platform provisioning
Terraform is used to declare the platform components and keep setup reproducible.

### kind for local Kubernetes
kind provides a local Kubernetes cluster suitable for portfolio demonstration, screenshots and CI experimentation.

### Argo CD for GitOps
Argo CD continuously compares the live Kubernetes state against the desired state stored in Git.

### Helm for app packaging
The FastAPI app is deployed using a Helm chart so configuration can be reused across environments.

### nginx Ingress
nginx simulates production-style routing into the cluster.

## Request Flow

```text
Browser / curl
   |
   v
nginx Ingress Controller
   |
   v
Kubernetes Service
   |
   v
FastAPI Pod
```

## Deployment Flow

```text
Git commit
   |
   v
GitHub Actions validation
   |
   v
Argo CD detects desired state change
   |
   v
Kubernetes reconciles deployment
```
