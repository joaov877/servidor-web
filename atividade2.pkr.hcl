
packer {
  required_plugins {
    docker = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "python" {
  image  = "ubuntu:jammy"
  commit = true

  changes = [
    "WORKDIR /app"
  ]
}

build {
  name    = "ambiente-dev-python"
  sources = ["source.docker.python"]

  provisioner "shell" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get update",
      "apt-get install -y python3 python3-pip",
      "mkdir -p /app",
      "python3 -m pip install Flask"
    ]
  }

  post-processor "docker-tag" {
    repository = "ambiente-dev-python"
    tags       = ["v1"]
  }
}
