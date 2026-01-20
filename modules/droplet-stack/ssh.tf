resource "digitalocean_ssh_key" "default" {
  name       = local.name
  public_key = file(pathexpand(var.ssh_public_key_path))
}
