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
