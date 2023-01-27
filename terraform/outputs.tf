output "droplet_ip" {
  value = join("@", [digitalocean_droplet.droplet.name], [digitalocean_droplet.droplet.ipv4_address])
}