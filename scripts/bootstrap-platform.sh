#!/bin/bash
# Half of the bootstrap worth re-running by hand later (e.g. after argocd/monitoring were torn
# down to save cost, and are being brought back). Assumes k3s/Helm already installed.
set -euo pipefail

# Grafana's admin password (platform/monitoring/grafana-values.yaml: admin.existingSecret) -
# generated here so this script stays self-contained. Lives only in a shell variable, never
# written to disk - no `set -x` on purpose, so it never hits stdout/logs.
k3s kubectl create namespace monitoring --dry-run=client -o yaml | k3s kubectl apply -f -
PW=$(openssl rand -base64 18)
k3s kubectl create secret generic grafana-admin-credentials -n monitoring --from-literal=admin-user=admin --from-literal=admin-password="$PW" --dry-run=client -o yaml | k3s kubectl apply -f -

# Postgres credentials (platform/postgresql/postgresql-values.yaml: auth.existingSecret) - same
# reasoning as Grafana's, plus: generated before Argo CD ever syncs the postgresql chart, so its
# own random-password generation never fights it on later syncs. news-explorer's copy
# (apps/news-explorer/values.yaml: postgres.existingSecret) is duplicated from the same variable
# since Secrets can't be referenced across namespaces.
k3s kubectl create namespace database --dry-run=client -o yaml | k3s kubectl apply -f -
k3s kubectl create namespace apps --dry-run=client -o yaml | k3s kubectl apply -f -
ADMIN_PW=$(openssl rand -base64 18)
USER_PW=$(openssl rand -base64 18)
k3s kubectl create secret generic postgresql-credentials -n database --from-literal=postgres-password="$ADMIN_PW" --from-literal=password="$USER_PW" --dry-run=client -o yaml | k3s kubectl apply -f -
k3s kubectl create secret generic news-explorer-postgres-credentials -n apps --from-literal=password="$USER_PW" --dry-run=client -o yaml | k3s kubectl apply -f -

# --dry-run=client | apply here too (not plain `create namespace`), so this script is safe to re-run.
k3s kubectl create namespace argocd --dry-run=client -o yaml | k3s kubectl apply -f -
# --server-side avoids a "too long" error on the applicationsets.argoproj.io CRD.
k3s kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --server-side --force-conflicts
k3s kubectl -n argocd wait --for=condition=Available deployment --all --timeout=300s
# No TLS yet, so argocd-server must serve plain HTTP behind the Ingress.
k3s kubectl patch configmap argocd-cmd-params-cm -n argocd --type merge -p '{"data":{"server.insecure":"true"}}'
k3s kubectl rollout restart deployment argocd-server -n argocd
k3s kubectl rollout status deployment argocd-server -n argocd --timeout=180s
k3s kubectl apply -f https://raw.githubusercontent.com/khainouski/news-platform-deploy/main/argocd/root-application.yaml

echo "news-explorer platform bootstrap complete ($(date -u +%FT%TZ))" >> /var/log/project-bootstrap.log
