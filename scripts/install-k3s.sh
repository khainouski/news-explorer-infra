#!/bin/bash
# First-boot-only half of the bootstrap. Split from bootstrap-platform.sh because that half is
# the one worth re-running by hand later (e.g. after tearing down argocd/monitoring to save cost)
# - k3s itself never needs reinstalling.
set -euo pipefail

curl -sfL https://get.k3s.io | sh -
systemctl enable k3s
systemctl start k3s
k3s kubectl wait --for=condition=Ready node --all --timeout=180s
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
