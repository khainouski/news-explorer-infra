variable "region" {
  description = "DigitalOcean region slug"
  type        = string
  default     = "fra1"
}

variable "droplet_size" {
  description = "DigitalOcean droplet size slug — small on purpose, dev is disposable"
  type        = string
  default     = "s-1vcpu-2gb-70gb-intel"
}

variable "ssh_public_key_path" {
  description = "Path to the local SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "domain_name" {
  description = "DNS zone to point at this environment's droplet (e.g. \"goskills.xyz\"). Leave empty to skip DNS — dev is disposable, so this defaults off; set it in terraform.tfvars to test DNS end-to-end here."
  type        = string
  default     = ""
}

variable "additional_dns_records" {
  description = "Extra subdomain labels (e.g. [\"argocd\", \"grafana\"]) that should also point at this droplet, alongside the root record. Ignored when domain_name is empty."
  type        = list(string)
  default     = []
}
