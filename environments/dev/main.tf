module "droplet_stack" {
  source = "../../modules/droplet-stack"

  environment         = "dev"
  region              = var.region
  droplet_size        = var.droplet_size
  ssh_public_key_path = var.ssh_public_key_path
  domain_name         = var.domain_name
}
