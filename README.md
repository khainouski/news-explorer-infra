# news-explorer-infra

Terraform infrastructure for `news-explorer`: DigitalOcean Droplet + Firewall + SSH key,
bootstraps k3s via cloud-init. The application isn't deployed from here — see `news-explorer`
(Helm chart) and `news-explorer-gitops` (Argo CD).

## Structure

```text
modules/droplet-stack/   reusable module (ssh key + droplet + firewall)
environments/dev/         only environment right now
cloud-init.yaml            droplet bootstrap script
```

## Usage

```bash
export DIGITALOCEAN_TOKEN="dop_v1_..."   # Custom Scopes: Droplet, SSH Key, Firewall — CRUD

cd environments/dev
terraform init
terraform plan
terraform apply

terraform state list
terraform destroy
```

```bash
terraform output droplet_ipv4
terraform output -raw ssh_command
```
