output "droplet_id" {
  description = "DigitalOcean droplet ID"
  value       = module.droplet_stack.droplet_id
}

output "droplet_ipv4" {
  description = "Public IPv4 address"
  value       = module.droplet_stack.droplet_ipv4
}

output "droplet_ipv6" {
  description = "Public IPv6 address"
  value       = module.droplet_stack.droplet_ipv6
}

output "ssh_command" {
  description = "Command for connecting to the server"
  value       = module.droplet_stack.ssh_command
}

output "application_url" {
  description = "Temporary application URL without DNS"
  value       = module.droplet_stack.application_url
}

output "fqdn" {
  description = "Public hostname backed by the DNS record (null when domain_name is not set)"
  value       = module.droplet_stack.fqdn
}
