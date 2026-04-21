terraform {
  required_version = ">= 1.6"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# ─────────────────────────────────────────────
# Provider: Docker (runs locally — no cloud needed)
# In this example I use Podman.
# ─────────────────────────────────────────────
provider "docker" {
  host = "unix:///run/user/1000/podman/podman.sock"
}

# ─────────────────────────────────────────────
# Network: shared bridge so containers can talk
# ─────────────────────────────────────────────
resource "docker_network" "homelab_net" {
  name   = var.network_name
  driver = "bridge"
}

# ─────────────────────────────────────────────
# Volume: persistent storage for postgres data
# ─────────────────────────────────────────────
resource "docker_volume" "postgres_data" {
  name = "${var.project_name}_postgres_data"
}

# ─────────────────────────────────────────────
# Images: pull from Docker Hub
# ─────────────────────────────────────────────
resource "docker_image" "nginx" {
  name         = "nginx:${var.nginx_version}"
  keep_locally = false
}

resource "docker_image" "postgres" {
  name         = "postgres:${var.postgres_version}"
  keep_locally = false
}

resource "docker_image" "portainer" {
  name         = "portainer/portainer-ce:latest"
  keep_locally = false
}

# ─────────────────────────────────────────────
# Container: Nginx — web server (port 8080)
# ─────────────────────────────────────────────
resource "docker_container" "web" {
  name    = "${var.project_name}-nginx"
  image   = docker_image.nginx.image_id
  restart = "unless-stopped"

  ports {
    internal = 80
    external = var.nginx_port
  }

  networks_advanced {
    name = docker_network.homelab_net.name
  }
}

# ─────────────────────────────────────────────
# Container: PostgreSQL — database (port 5432)
# ─────────────────────────────────────────────
resource "docker_container" "db" {
  name    = "${var.project_name}-postgres"
  image   = docker_image.postgres.image_id
  restart = "unless-stopped"

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}",
  ]

  ports {
    internal = 5432
    external = var.db_port
  }

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.homelab_net.name
  }
}

# ─────────────────────────────────────────────
# Container: Portainer — Docker management UI (port 9000)
# ─────────────────────────────────────────────
resource "docker_container" "portainer" {
  name    = "${var.project_name}-portainer"
  image   = docker_image.portainer.image_id
  restart = "unless-stopped"  # may not work for Podman

  ports {
    internal = 9000
    external = var.portainer_port
  }

  # Portainer needs access to the Docker socket to manage containers
  volumes {
    #host_path      = "/var/run/docker.sock"
    host_path = "/run/user/1000/podman/podman.sock"
    container_path = "/var/run/docker.sock"
  }

  networks_advanced {
    name = docker_network.homelab_net.name
  }
}
