variable "project_name" {
  description = "Prefix used for all container and volume names"
  type        = string
  default     = "homelab"
}

variable "network_name" {
  description = "Name of the Docker bridge network shared by all containers"
  type        = string
  default     = "homelab-net"
}

# ── Nginx ───────────────────────────────────
variable "nginx_version" {
  description = "Nginx Docker image tag (e.g. 'alpine', 'latest', '1.25-alpine')"
  type        = string
  default     = "alpine"
}

variable "nginx_port" {
  description = "Host port mapped to Nginx container port 80"
  type        = number
  default     = 8080
}

# ── PostgreSQL ──────────────────────────────
variable "postgres_version" {
  description = "PostgreSQL image tag (e.g. '15-alpine', '16-alpine')"
  type        = string
  default     = "15-alpine"
}

variable "db_user" {
  description = "PostgreSQL superuser username"
  type        = string
  default     = "homelab"
}

variable "db_password" {
  description = "PostgreSQL superuser password — override this in terraform.tfvars!"
  type        = string
  sensitive   = true   # hides the value from tofu plan/apply output
  default     = "changeme123"
}

variable "db_name" {
  description = "PostgreSQL default database name"
  type        = string
  default     = "homelabdb"
}

variable "db_port" {
  description = "Host port mapped to PostgreSQL container port 5432"
  type        = number
  default     = 5432
}

# ── Portainer ───────────────────────────────
variable "portainer_port" {
  description = "Host port mapped to Portainer UI container port 9000"
  type        = number
  default     = 9000
}
