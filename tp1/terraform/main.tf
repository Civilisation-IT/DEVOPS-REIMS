terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

variable "project_id" {
  type        = string
  description = ""
  default = "ace0a8c0-8b24-4ad3-a030-6bcae7502e93"
}

provider "scaleway" {
  zone   = "fr-par-2"
  region = "fr-par"
}

resource "scaleway_instance_ip" "public_ip" {
  project_id = var.project_id
}

resource "scaleway_instance_security_group" "www" {
  project_id              = var.project_id
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action   = "accept"
    port     = "22"
    ip_range = "0.0.0.0/0"
  }

  inbound_rule {
    action = "accept"
    port   = "80"
  }

  inbound_rule {
    action = "accept"
    port   = "443"
  }
}

resource "scaleway_instance_server" "web" {
  project_id = var.project_id
  type       = "DEV1-M"
  image      = "debian_trixie"

  tags = ["killian", "cesi"]

  ip_id = scaleway_instance_ip.public_ip.id

  root_volume {
    size_in_gb = 40
  }

  security_group_id = scaleway_instance_security_group.www.id
}

resource "scaleway_iam_ssh_key" "main" {
  name       = "main"
  public_key = "replace_with_your_public_key"
  project_id = var.project_id
}

output "public_ip" {
  value = scaleway_instance_ip.public_ip.address
}