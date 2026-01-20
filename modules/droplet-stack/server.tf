resource "digitalocean_droplet" "app" {
  name   = local.name
  image  = var.droplet_image
  region = var.region
  size   = var.droplet_size

  ipv6       = true
  monitoring = true

  ssh_keys = [
    digitalocean_ssh_key.default.id
  ]

  # Both environments/<env>/ and modules/droplet-stack/ sit exactly two
  # directories below the repo root, so this relative path resolves the
  # same regardless of which environment calls the module.
  user_data = file("${path.module}/../../cloud-init.yaml")

  tags = local.common_tags
}
