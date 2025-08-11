#!/bin/bash

source ../psql-mcp.env

main() {
  install_dependencies
  install_psql
  ./start-psql-db.sh
}

install_dependencies() {
  if [[ "$(which python)" == "" ]]; then
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
  if [[ "$(which docker)" == "" ]]; then
    echo "Installing Docker..."
    ./_install-docker.sh
  fi
  if [[ "$(which node)" == "" ]]; then
    echo "Installing Node.js..."
    case $(uname) in
      Darwin)
	wget https://nodejs.org/dist/v22.18.0/node-v22.18.0.pkg
 	sudo installer -pkg ./node-v22.18.0.pkg -target /	
#	npm install -g npx
      Linux)
	sudo apt install npm
	npm install -g npx
	;;
      *)
	echo "Unsupported OS: $(uname)"
	exit -1
    esac
  fi
}

install_psql() {
  # see: https://hub.docker.com/_/postgres
  if [[ "$(docker images | grep postgres)" == "" ]]; then
    echo "Pulling PostgreSQL Docker image..."
    docker pull postgres:15
  fi
  # see: https://hub.docker.com/r/alpine/psql
  if [[ "$(docker images | grep alpine/psql)" == "" ]]; then
    echo "Pulling PostgreSQL client Docker image..."
    docker pull alpine/psql:17.5
  fi
}

main "$@"
