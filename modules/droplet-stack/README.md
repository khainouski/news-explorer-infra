# droplet-stack

Reusable module: one DigitalOcean Droplet + its SSH key + its Firewall.

## Usage

```hcl
module "droplet_stack" {
  source = "../../modules/droplet-stack"

  environment  = "dev"
  region       = "fra1"
  droplet_size = "s-1vcpu-2gb-70gb-intel"
}
```

## Inputs

| Name | Description | Default |
|---|---|---|
| `project_name` | Naming/tag prefix | `"news-explorer"` |
| `environment` | Environment name — required | — |
| `region` | DigitalOcean region slug — required | — |
| `droplet_size` | DigitalOcean droplet size slug — required | — |
| `droplet_image` | OS image slug | `"ubuntu-24-04-x64"` |
| `ssh_public_key_path` | Path to local SSH public key | `"~/.ssh/id_ed25519.pub"` |
| `domain_name` | DNS zone to point at this droplet — empty disables DNS | `""` |
| `manage_dns_zone` | Whether this call creates the zone itself vs. just adding a record to one another environment already created (a zone can only exist once per domain name) | `true` |
| `dns_record_name` | Record name within the zone — `"@"` for root, or a subdomain label | `"@"` |

## Outputs

`droplet_id`, `droplet_ipv4`, `droplet_ipv6`, `ssh_command`, `application_url`, `fqdn` (null when
`domain_name` is unset).

## Creates

`digitalocean_ssh_key`, `digitalocean_droplet` (monitoring on, bootstrapped via
`cloud-init.yaml.tftpl` + `scripts/*.sh` at the repo root — see the root README/CLAUDE.md),
`digitalocean_firewall` (22/80/443 open to all — key-only SSH auth is the real
control, root has no password). `digitalocean_domain` + `digitalocean_record` only when
`domain_name` is set — most environments (e.g. `dev`) leave it unset and skip DNS entirely.

## DNS across multiple environments

The DNS zone itself is a single DigitalOcean resource per domain name — it can't be created twice.
If more than one environment ever shares the same `domain_name` (e.g. `dev` and `production` both
under `goskills.xyz`), only one of them should set `manage_dns_zone = true` (the owner, that
creates the zone); every other environment sets it to `false` and the module looks the zone up via
a `data "digitalocean_domain"` instead, adding only its own record to it.
