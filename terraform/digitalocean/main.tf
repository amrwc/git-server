locals {
  project_name  = "Git-Server-project"
  network_name  = "git-server-network"
  droplet_name  = "Git-Server"
  firewall_name = "git-server-firewall"
}

# Create a new project
resource "digitalocean_project" "git_server_project" {
  name        = local.project_name
  description = "A project to group Git Server-related resources."
  purpose     = "Service or API"
  environment = "Production"
}

# Create a Virtual Private Cloud (VPC) – a private network
# See: https://www.digitalocean.com/community/tutorials/understanding-ip-addresses-subnets-and-cidr-notation-for-networking
resource "digitalocean_vpc" "git_server_vpc" {
  name     = local.network_name
  region   = var.droplet_region
  ip_range = var.vpc_ip_range
}

# Create a new Droplet
resource "digitalocean_droplet" "git_server_droplet" {
  image              = var.droplet_image_type
  name               = local.droplet_name
  region             = var.droplet_region
  size               = var.droplet_size
  backups            = true
  vpc_uuid           = digitalocean_vpc.git_server_vpc.id
  private_networking = true
  resize_disk        = false

  # Add the given SSH keys to the instance to allow remote provisioning and root login.
  ssh_keys = [
    data.digitalocean_ssh_key.do_terraform_ssh_key.id,
    data.digitalocean_ssh_key.do_login_ssh_key.id,
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(pathexpand(var.do_terraform_ssh_key_path))
    timeout     = "2m"
  }

  # See: https://git-scm.com/book/en/v2/Git-on-the-Server-Setting-Up-the-Server
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",

      "addgroup --gid 10001 --system git",
      "adduser --ingroup git --system --uid 10000 git",

      "mkdir /home/git/.ssh",
      "chmod 700 /home/git/.ssh",
      "touch /home/git/.ssh/authorized_keys",
      "chmod 600 /home/git/.ssh/authorized_keys",
      "chown --recursive git:git /home/git/.ssh",

      "sudo echo \"$(which git-shell)\" >> /etc/shells",
      "sudo chsh git -s \"$(which git-shell)\"",
    ]
  }
}

# Assign the Droplet to the new project
resource "digitalocean_project_resources" "git_server_resource" {
  project   = digitalocean_project.git_server_project.id
  resources = [
    digitalocean_droplet.git_server_droplet.urn,
  ]
}

resource "digitalocean_firewall" "git_server_droplet_firewall" {
  name = local.firewall_name

  droplet_ids = [
    digitalocean_droplet.git_server_droplet.id,
  ]

  # Allow SSH inbound traffic.
  # NOTE: If possible, specify your exact public IP address here as to stop others from accessing this port.
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }
}
