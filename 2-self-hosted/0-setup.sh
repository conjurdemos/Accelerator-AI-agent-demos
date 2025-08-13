#!/bin/bash

main() {
  install_go
  install_mcphost
  install_ollama
}

install_go() {
  if [[ "$(which go)" == "" ]]; then
    case $(uname) in
      Linux)
        wget https://go.dev/dl/go1.24.6.linux-amd64.tar.gz
        sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.24.6.linux-amd64.tar.gz
        rm go1.24.6.linux-amd64.tar.gz
        sudo rm -f /usr/local/bin/go* && sudo ln -s /usr/local/go/bin/go* /usr/local/bin
        ;;
      Darwin)
	wget https://go.dev/dl/go1.24.6.darwin-arm64.pkg
	sudo installer -pkg ./go1.24.6.darwin-arm64.pkg -target /
	rm -f go1.24.6.darwin-arm64.pkg
        sudo rm -f /usr/local/bin/go* && sudo ln -s /usr/local/go/bin/* /usr/local/bin
	;;
      *)
	echo "Unsupported OS: $(uname)"
	exit -1
    esac
  fi
}

install_mcphost() {
  PATH=$PATH:$(go env GOPATH)/bin
  if [[ "$(which mcphost)" == "" ]]; then
    echo "Installing mcphost..."
    go install github.com/mark3labs/mcphost@latest
  fi
}

install_ollama() {
  if [[ "$(which ollama)" == "" ]]; then
    echo "Installing ollama..."
    OS_TYPE=$(uname -s)
    ARCH_TYPE=$(uname -m)
    case $OS_TYPE-$ARCH_TYPE in
        Linux-x86_64 | Linux-aarch64)
          curl -fsSL https://ollama.com/install.sh | sh
          ;;
        Darwin-x86_64 | Darwin-arm64)
          curl -LO https://ollama.com/download/Ollama-darwin.zip
          unzip ./Ollama-darwin.zip
          sudo mv ./Ollama.app /Applications
          rm ./Ollama-darwin.zip
          /Applications/Ollama.app/Contents/MacOS/Ollama
          ;;
        *)
        echo "Unknown OS_TYPE-ARCH_TYPE: $OS_TYPE-$ARCH_TYPE"
        exit -1
    esac
  fi
}

main "$@"
