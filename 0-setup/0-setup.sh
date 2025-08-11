#!/bin/bash

source ../psql-mcp.env

main() {
  install_python
  install_poetry
  install_nodejs
  install_docker
}

install_python() {
  if [[ "$(which python3)" == "" ]]; then
    case $(uname) in
      Darwin)
	brew install python@3.11
	brew install pipx
	;;
      Linux)
	sudo apt update
	sudo add-apt-repository ppa:deadsnakes/ppa -y
	sudo apt update
	sudo apt install -y python3.11
	sudo apt install -y python3-pip
	sudo apt install -y pipx
	;;
      *)
	echo "Unsupported OS $(uname)"
	exit -1
      esac
  fi
}

install_poetry() {
  if [[ "$(which poetry)" == "" ]]; then
    echo "Installing poetry..."
    case $(uname) in
      Darwin)
	pipx install poetry
	pipx ensurepath
	;;
      Linux)
    	sudo apt install -y python3-poetry
	;;
      *)
	echo "Unsupported OS $(uname)"
	exit -1
    esac
  fi
}

install_nodejs() {
  if [[ "$(which node)" == "" ]]; then
    echo "Installing Node.js..."
    case $(uname) in
      Darwin)
	wget https://nodejs.org/dist/v22.18.0/node-v22.18.0.pkg
 	sudo installer -pkg ./node-v22.18.0.pkg -target /	
	;;
      Linux)
	sudo apt install -y npm
	;;
      *)
	echo "Unsupported OS: $(uname)"
	exit -1
    esac
  fi
}

install_docker() {
  if [[ "$(which docker)" == "" ]]; then
    echo "Installing Docker..."
    case $uname in
      Darwin)
	echo "Download Docker Desktop from:"
	echo "  https://docs.docker.com/get-started/introduction/get-docker-desktop/"
	echo; echo
	exit 1
	;;
      Linux)
	# Assumes Linux amd64
	sudo apt-get remove docker docker-engine docker.io
	sudo apt-get update
	sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
	sudo apt-get update
	sudo apt-get install -y docker-ce
	sudo usermod -aG docker $USER
	newgrp docker
	;;
      *)
	echo "Unsupported OS: $(uname)"
	exit -1
    esac
  fi
}

main "$@"
