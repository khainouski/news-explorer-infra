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

## Outputs

`droplet_id`, `droplet_ipv4`, `droplet_ipv6`, `ssh_command`, `application_url`.

## Creates

`digitalocean_ssh_key`, `digitalocean_droplet` (monitoring on, bootstrapped via `cloud-init.yaml`
at the repo root), `digitalocean_firewall` (22/80/443 open to all — key-only SSH auth is the real
control, root has no password).
