
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

  changes = [
    "EXPOSE 80",
    "CMD [\"apachectl\", \"-D\", \"FOREGROUND\"]"
  ]
}

build {
  name    = "meu-apache-packer"
  sources = ["source.docker.ubuntu_jammy"]

  # 1. Instalar o Apache e criar o diretório do site
  provisioner "shell" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get update",
      "apt-get install -y apache2",
      "mkdir -p /var/www/html"
    ]
  }

  # 2. Copiar o HTML depois da instalação do Apache
  provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"
  }

  # 3. Gerar a imagem final com o nome exigido
  post-processor "docker-tag" {
    repository = "meu-apache-packer"
    tags       = ["latest"]
  }
}
