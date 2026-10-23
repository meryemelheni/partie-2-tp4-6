terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

variable "host_ip" {
  description = "IP de la VM cible"
  type        = string
}

variable "external_port" {
  description = "Port externe du conteneur"
  type        = number
}

provider "docker" {
  host = "ssh://vagrant@${var.host_ip}:22"
  ssh_opts = [
    "-o", "StrictHostKeyChecking=no",
    "-o", "UserKnownHostsFile=/dev/null",
    "-i", "/home/meryem/terraform/cv-lab/.vagrant/machines/cv-vm1/virtualbox/private_key"
  ]
}

resource "docker_image" "cv" {
  name         = "maryemelheni/mon-cv:latest"
  keep_locally = false
}

resource "docker_container" "cv" {
  image = docker_image.cv.image_id
  name  = "cv_terraform"
  ports {
    internal = 80
    external = var.external_port
  }
}
