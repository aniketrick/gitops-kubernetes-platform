#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f argocd/portfolio-api-app.yaml
kubectl get applications -n argocd
