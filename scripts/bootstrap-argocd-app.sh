#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f argocd/applications/portfolio-api.yaml
kubectl get applications -n argocd
