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

  # Relative paths resolve two directories below the repo root, same for every
  # environment - see cloud-init.yaml.tftpl for why these are templated in.
  user_data = templatefile("${path.module}/../../cloud-init.yaml.tftpl", {
    install_k3s_script        = file("${path.module}/../../scripts/install-k3s.sh")
    bootstrap_platform_script = file("${path.module}/../../scripts/bootstrap-platform.sh")
  })

  tags = local.common_tags
}
