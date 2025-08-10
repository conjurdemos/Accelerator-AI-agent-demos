#!/bin/bash

source ../psql-mcp.env

main() {
  install_dependencies
  install_psql
  ./start-psql-db.sh
}

install_dependencies() {
  if [[ "$(which python)" == "" ]]; then
    if [[ "$(uname)" == "Darwin" ]]; then
      brew install python@3.11
    elif [[ "$(uname)" == "Linux" ]]; then
      sudo apt update
      sudo add-apt-repository ppa:deadsnakes/ppa -y
      sudo apt update
      sudo apt install -y python3.11
      sudo apt install -y python3-pip
      sudo apt install -y pipx
    fi
  fi
  if [[ "$(which poetry)" == "" ]]; then
    echo "Installing poetry..."
    sudo apt install -y python3-poetry
  fi
  if [[ "$(which docker)" == "" ]]; then
    echo "Installing Docker..."
    ./_install-docker.sh
  fi
  if [[ "$(which node)" == "" ]]; then
    echo "Installing Node.js..."
    sudo apt install npm
    npm install -g npx
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
