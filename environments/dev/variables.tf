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
