#!/bin/bash

source ../psql-mcp.env

main() {
  install_dependencies
  install_psql
  ./start-psql-db.sh
}

install_dependencies() {
  if [[ "$(which poetry)" == "" ]]; then
    echo "Installing poetry..."
  fi
  if [[ "$(which docker)" == "" ]]; then
    echo "Installing Docker..."
    ./_install-docker.sh
  fi
  if [[ "$(which node)" == "" ]]; then
    echo "Installing Node.js..."
    # Download and install nvm:
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    # in lieu of restarting the shell
    \. "$HOME/.nvm/nvm.sh"
    # Download and install Node.js:
    nvm install 22
    # Verify the Node.js version:
    node -v # Should print "v22.18.0".
    nvm current # Should print "v22.18.0".
    # Verify npm version:
    npm -v # Should print "10.9.3".
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
