output "droplet_id" {
  description = "DigitalOcean droplet ID"
  value       = digitalocean_droplet.app.id
}

output "droplet_ipv4" {
  description = "Public IPv4 address"
  value       = digitalocean_droplet.app.ipv4_address
}

output "droplet_ipv6" {
  description = "Public IPv6 address"
  value       = digitalocean_droplet.app.ipv6_address
}

output "ssh_command" {
  description = "Command for connecting to the server"
  value       = "ssh root@${digitalocean_droplet.app.ipv4_address}"
}

output "application_url" {
  description = "Temporary application URL without DNS"
  value       = "http://${digitalocean_droplet.app.ipv4_address}"
}
