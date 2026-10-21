packer {
  required_plugins {
    docker = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu_jammy" {
  image  = "ubuntu:jammy"
  commit = true
}

build {
  name    = "meu-projeto-packer"
  sources = ["source.docker.ubuntu_jammy"]

  # 1. Provisioner FILE para copiar o ficheiro local para a imagem
  provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"
  }

  # 2. Provisioner SHELL para instalar o apache2
  provisioner "shell" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get update",
      "apt-get install -y apache2"
    ]
  }

  # 3. POST-PROCESSOR para renomear/taggear a imagem final
  post-processor "docker-tag" {
    repository = "meu-projeto-packer"
    tags       = ["latest"]
  }
}
