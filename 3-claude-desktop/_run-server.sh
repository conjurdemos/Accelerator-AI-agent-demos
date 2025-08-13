#!/bin/bash
case $(uname) in
  Darwin)
    export PATH=$PATH:~/.local/bin:~/Applications/homebrew/bin
    ;;
  Linux)
    ;;
  *)
    echo "Unsupported OS: $(uname)"
    exit -1
esac
source ../psql-mcp.env
poetry -q update
poetry run python mcp-psql.py
