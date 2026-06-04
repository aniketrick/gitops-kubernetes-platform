#!/usr/bin/env bash
set -euo pipefail

echo "Namespaces"
kubectl get ns

echo "Pods"
kubectl get pods -A

echo "Services"
kubectl get svc -A

echo "Argo CD applications"
kubectl get applications -n argocd || true
