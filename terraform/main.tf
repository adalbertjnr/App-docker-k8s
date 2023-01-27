data "digitalocean_ssh_key" "ssh" {
  name = var.ssh_key
}

resource "digitalocean_droplet" "droplet" {
  image    = "ubuntu-22-04-x64"
  name     = "jenkins"
  region   = var.region
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh.id]
  
  provisioner "local-exec" {
    command = "sed -i '1!d' hosts"
  }

  provisioner "local-exec" {
    command = "echo ${self.ipv4_address} >> hosts"
  }


}

resource "null_resource" "ansible" {
  depends_on = [digitalocean_kubernetes_cluster.kcluster]
  provisioner "local-exec" {
    command = "ansible-playbook playbooks/playbook.yaml"
  }
}

resource "digitalocean_kubernetes_cluster" "kcluster" {
  name    = "k8s"
  region  = var.region
  version = "1.24.8-do.0"

  node_pool {
    name       = "d-pool"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

resource "local_file" "local" {
  content = digitalocean_kubernetes_cluster.kcluster.kube_config.0.raw_config
  filename = "kube_config.yaml"
}