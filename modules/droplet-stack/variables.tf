variable "project_name" {
  description = "Project name, used as a naming/tag prefix"
  type        = string
  default     = "news-explorer"
}

variable "environment" {
  description = "Environment name (dev, staging, production, ...) — used in resource naming and tags"
  type        = string
}

variable "region" {
  description = "DigitalOcean region slug"
  type        = string
}

variable "droplet_size" {
  description = "DigitalOcean droplet size slug"
  type        = string
}

variable "droplet_image" {
  description = "Operating system image slug"
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "ssh_public_key_path" {
  description = "Path to the local SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "domain_name" {
  description = "DNS zone to point at this droplet (e.g. \"goskills.xyz\"). Empty string disables DNS for this environment — the intended default for throwaway/dev environments."
  type        = string
  default     = ""
}

variable "manage_dns_zone" {
  description = "Whether this environment owns/creates the DNS zone (digitalocean_domain) itself. The zone can only be created once per domain name on the account — set this false for any additional environment that shares a domain_name already created elsewhere, so it only adds its own record via data source instead of re-creating the zone. Ignored when domain_name is empty."
  type        = bool
  default     = true
}

variable "dns_record_name" {
  description = "Record name within the zone, DigitalOcean convention: \"@\" for the root domain, otherwise a subdomain label (e.g. \"grafana\"). Ignored when domain_name is empty."
  type        = string
  default     = "@"
}
