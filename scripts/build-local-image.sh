#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="portfolio-api:latest"
CLUSTER_NAME="gitops-dev"

echo "Building Docker image: ${IMAGE_NAME}"
docker build -t "${IMAGE_NAME}" apps/portfolio-api

echo "Loading image into kind cluster: ${CLUSTER_NAME}"
kind load docker-image "${IMAGE_NAME}" --name "${CLUSTER_NAME}"

echo "Done. Image is available inside the kind cluster."
