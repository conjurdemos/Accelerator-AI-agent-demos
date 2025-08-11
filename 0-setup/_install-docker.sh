#!/bin/bash


if [[ "$(uname)" == "Darwin" ]]; then
  echo "Download Docker Desktop from:"
  echo "  https://docs.docker.com/get-started/introduction/get-docker-desktop/"
  echo; echo
  exit 1
fi

# Assumes Linux amd64
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
xenial \
stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker $USER
newgrp docker
