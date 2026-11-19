# GitOps Kubernetes Platform

A local Kubernetes platform that comes up with one `terraform apply`. Terraform creates a two-node kind cluster and installs the nginx ingress controller and Argo CD. Argo CD then watches this repo and deploys a small FastAPI app from the Helm chart in `helm/portfolio-api`.

I built it to learn how GitOps works in practice. Nobody runs `kubectl apply` by hand: you change a file in Git, and Argo CD makes the cluster match it.

## How it works

```text
git push
   │
   ├──► GitHub Actions: terraform fmt and validate, helm lint, helm template, docker build
   │
   ▼
GitHub repo (main branch)
   │  Argo CD checks for changes
   ▼
kind cluster (1 control plane, 1 worker), created by Terraform
   ├── ingress-nginx      (Helm, installed by Terraform)
   ├── argocd             (Helm, installed by Terraform)
   └── portfolio-api      (Helm chart in this repo, deployed by Argo CD)
         2 replicas, readiness and liveness checks on /health, CPU and memory limits
```

## What's in it

- **Terraform** creates the cluster and installs ingress-nginx and Argo CD, with pinned chart versions.
- **The Argo CD Application** has automated sync with `prune` and `selfHeal`. If someone changes the cluster by hand, Argo CD puts it back. If a file is removed from Git, the resource is removed from the cluster.
- **The Helm chart** runs the API with two replicas, health checks, resource requests and limits, and an ingress at `portfolio.local`.
- **To roll back**, you revert the commit in Git and Argo CD syncs the old version.

## Run it yourself

You'll need Docker, Terraform, kubectl, Helm and kind.

```bash
# 1. Create the cluster and install ingress-nginx and Argo CD
cd terraform/environments/dev
terraform init
terraform apply

# 2. Build the app image and load it into kind
cd ../../..
./scripts/build-local-image.sh

# 3. Tell Argo CD to deploy the app
kubectl apply -f argocd/applications/portfolio-api.yaml

# 4. Check it
./scripts/check-platform.sh
kubectl port-forward svc/portfolio-api -n portfolio-api 8000:80
curl http://localhost:8000/health
```

To open the Argo CD UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
```

Then go to https://localhost:8080 and log in as `admin`.

To clean up, run `terraform destroy`, or `kind delete cluster --name gitops-dev`.

## Not done yet

- **Monitoring.** I want to install Prometheus and Grafana through Argo CD and alert on failed syncs and pods that keep restarting.
- **Network policies and RBAC** for the app namespace.
- **Image publishing.** The image is built locally and loaded into kind. Next it should be pushed to a registry by GitHub Actions, with a proper version tag instead of `latest`.
- **A real cloud cluster.** This runs on kind on my laptop. I'd like to run the same setup on EKS for a day and record what it costs.
