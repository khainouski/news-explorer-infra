# DNS is optional per environment — most environments (e.g. dev) don't need a public domain,
# only one (typically production) does. Leave var.domain_name empty to skip DNS entirely.
#
# The zone itself (digitalocean_domain) can only exist once per domain name on the account, so
# if more than one environment ever points at the same domain_name, only the owning environment
# should set manage_dns_zone = true — the rest look the zone up via data source and just add
# their own record to it.

resource "digitalocean_domain" "app" {
  count = var.domain_name != "" && var.manage_dns_zone ? 1 : 0

  name = var.domain_name
}

data "digitalocean_domain" "app" {
  count = var.domain_name != "" && !var.manage_dns_zone ? 1 : 0

  name = var.domain_name
}

resource "digitalocean_record" "app" {
  count = var.domain_name != "" ? 1 : 0

  domain = var.manage_dns_zone ? digitalocean_domain.app[0].name : data.digitalocean_domain.app[0].name
  type   = "A"
  name   = var.dns_record_name
  value  = digitalocean_droplet.app.ipv4_address
  ttl    = 3600
}

# Extra subdomains on the same zone, all pointing at the same droplet (Traefik routes by Host
# header once they land — see each service's Ingress). e.g. "argocd", "grafana", "kafka".
resource "digitalocean_record" "additional" {
  for_each = var.domain_name != "" ? toset(var.additional_dns_records) : toset([])

  domain = var.manage_dns_zone ? digitalocean_domain.app[0].name : data.digitalocean_domain.app[0].name
  type   = "A"
  name   = each.value
  value  = digitalocean_droplet.app.ipv4_address
  ttl    = 3600
}
