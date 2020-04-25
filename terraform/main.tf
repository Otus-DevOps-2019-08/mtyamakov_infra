terraform {
  # terraform version
  required_version = "0.12.8"
}

provider "google" {
  # provider version
  version = "2.15"

  # Project ID
  project = var.project

  region = var.region
}
resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    # Path to public key
    ssh-keys = "appuser:${file(var.public_key_path)}"

  }

  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = "appuser"
    agent = false
    # Path to private key
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }

}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Network name
  network = "default"
  # Allow rule
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Which addresses have access
  source_ranges = ["0.0.0.0/0"]
  # Targets for rule
  target_tags = ["reddit-app"]
}
