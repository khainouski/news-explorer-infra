# news-explorer-infra

**Terraform infrastructure for News Explorer** — a single DigitalOcean Droplet + Firewall +
SSH key, bootstrapped via cloud-init into a k3s cluster with Argo CD. The application
itself isn't deployed from here — this repo only stands up the box and hands off to Argo CD.
Related repos: [`news-explorer`](https://github.com/khainouski/news-explorer) (app code, image
this infra runs) and [`news-platform-deploy`](https://github.com/khainouski/news-platform-deploy)
(Argo CD/Helm — what actually gets deployed, pulled by `bootstrap-platform.sh` at boot).

## Structure

```text
environments/dev/                the only environment right now; thin wrapper that sets
                                  environment = "dev" and passes through region/size/DNS vars
modules/droplet-stack/           reusable module: ssh key + droplet + firewall + optional DNS
cloud-init.yaml.tftpl            droplet bootstrap template (repo root; loaded by the module
                                  via a relative path — see modules/droplet-stack/README.md)
scripts/install-k3s.sh           installs k3s + Helm - first boot only
scripts/bootstrap-platform.sh    secrets + Argo CD bootstrap - safe to re-run by hand later
```

A new environment (e.g. `production`) is added by copying `environments/dev/` and calling
`modules/droplet-stack` with a different `environment` value — the module is the only place
resource definitions live.

## Commands

All commands run from an environment directory, not the repo root:

```bash
export DIGITALOCEAN_TOKEN="dop_v1_..."   # Custom Scopes required: Droplet, SSH Key, Firewall, Tag — all CRUD
                                          # (Tag is easy to miss — apply fails with
                                          # "403: missing the required permission tag:create" without it)
cd environments/dev
terraform init
terraform plan
terraform apply
terraform destroy
```

```bash
terraform output droplet_ipv4
terraform output -raw ssh_command
terraform state list
```

No test suite/linter/CI here — validate with `terraform plan` (`validate`/`fmt` as needed).

**`terraform apply` creates real, billed DigitalOcean resources.** Treat it as a live droplet,
not a sandbox — always confirm before destroying or re-applying over existing state.

### Verifying a droplet after apply

```bash
ssh root@$(terraform output -raw droplet_ipv4)
cat /var/log/project-bootstrap.log      # appended by bootstrap-platform.sh once it finishes
sudo systemctl status k3s
sudo k3s kubectl get nodes              # one node, should reach Ready within ~30-60s
```

### What to configure, and where

| Setting | Where |
|---|---|
| Droplet size, region, SSH key path | `environments/dev/terraform.tfvars` (copy from `.tfvars.example`) |
| DNS (optional — off by default) | `domain_name` + `additional_dns_records` in the same `.tfvars` |
| DigitalOcean auth | `DIGITALOCEAN_TOKEN` env var — never a `.tf` file |
| What happens on first boot | `cloud-init.yaml.tftpl` (repo root, plain ASCII only) + `scripts/install-k3s.sh` + `scripts/bootstrap-platform.sh` |
