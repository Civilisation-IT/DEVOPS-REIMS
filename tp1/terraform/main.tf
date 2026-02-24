terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
    backend "s3" {
    endpoint                    = "https://s3.fr-par.scw.cloud"
    bucket                      = "tf-state-cesi-reims"
    key                         = "terraform.tfstate"
    region                      = "fr-par"
    skip_credentials_validation = true
    skip_region_validation      = true
    }
}

variable "project_id" {
  type        = string
  description = ""
  default = "ace0a8c0-8b24-4ad3-a030-6bcae7502e93"
}

variable "name" {
  type        = string
  description = "Your name, used for naming resources"
}

variable "dns_zone" {
  type        = string
  description = "The DNS Zone used for testing records."
  default = "lab-cesi.fr"
}

variable "scw_access_key" {
  type        = string
  description = "Scaleway Access Key"
}

variable "scw_secret_key" {
  type        = string
  description = "Scaleway Secret Key"
}

# variable "ssh_key" {
#   type        = string
#   description = "Your public ssh key"
# }

provider "scaleway" {
  access_key = var.scw_access_key
  secret_key = var.scw_secret_key
  project_id = var.project_id
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

  inbound_rule {
    action = "accept"
    port   = "8080"
  }

  inbound_rule {
    action = "accept"
    port   = "9090"
  }

  inbound_rule {
    action = "drop"
  }
}

resource "scaleway_instance_server" "web" {
  project_id = var.project_id
  type       = "DEV1-M"
  image      = "debian_trixie"

  tags = [var.name, "cesi"]

  ip_id = scaleway_instance_ip.public_ip.id

  root_volume {
    size_in_gb = 40
  }

  security_group_id = scaleway_instance_security_group.www.id
}

# resource "scaleway_iam_ssh_key" "main" {
#   count      = var.ssh_key != null && trimspace(var.ssh_key) != "" ? 1 : 0
#   name       = "${var.name}-ssh-key"
#   public_key = var.ssh_key == null ? "" : trimspace(var.ssh_key)
#   project_id = var.project_id
# }


resource "scaleway_domain_record" "web_A" {
  dns_zone = var.dns_zone
  name     = "${var.name}-serveur1"
  type     = "A"
  data     = scaleway_instance_ip.public_ip.address
  ttl      = 3600
}

output "public_ip" {
  value = scaleway_instance_ip.public_ip.address
}

output "complete_domain" {
  value = "${scaleway_domain_record.web_A.name}.${var.dns_zone}"
}
