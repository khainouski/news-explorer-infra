terraform {
  required_version = "~> 1.8"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# No explicit `token` argument — the provider reads it directly from the
# DIGITALOCEAN_TOKEN environment variable. Keeps the token out of any .tf file.
provider "digitalocean" {}
