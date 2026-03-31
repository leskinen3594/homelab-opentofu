output "web_url" {
  description = "Open this in your browser to see the Nginx welcome page"
  value       = "http://localhost:${var.nginx_port}"
}

output "portainer_url" {
  description = "Open this to manage all containers visually via Portainer"
  value       = "http://localhost:${var.portainer_port}"
}

output "db_connection" {
  description = "PostgreSQL connection details for your local client (DBeaver, TablePlus, etc.)"
  value = {
    host     = "localhost"
    port     = var.db_port
    database = var.db_name
    user     = var.db_user
    # Note: password is marked sensitive and not shown here
  }
}

output "network_name" {
  description = "Docker network name — all containers are discoverable by their container name on this network"
  value       = docker_network.homelab_net.name
}

output "container_names" {
  description = "Names of all containers created by this configuration"
  value = {
    web       = docker_container.web.name
    db        = docker_container.db.name
    portainer = docker_container.portainer.name
  }
}
