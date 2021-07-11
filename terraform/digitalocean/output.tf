output "droplet_public_ip" {
  value = digitalocean_droplet.git_server_droplet.ipv4_address
}
