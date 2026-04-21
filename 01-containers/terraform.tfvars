# terraform.tfvars
# Override any variable defaults here.
# This file is loaded automatically by OpenTofu.
# ⚠️  Add this file to .gitignore — it may contain secrets!

project_name     = "homelab"
network_name     = "homelab-net"

nginx_port       = 8080
nginx_version    = "alpine"

postgres_version = "15-alpine"
db_user          = "homelab"
db_password      = "changeme123"   # ← change this before using in production!
db_name          = "homelabdb"
db_port          = 5432

portainer_port   = 9000
