#!/bin/bash

if [[ "$1" != "" ]]; then
  MODEL=$1
else
  echo "No model name provided on command line, using default llama3.2:1b."
  MODEL=llama3.2:1b
fi

nohup ollama serve &
echo "Downloading model $MODEL..."
ollama pull $MODEL

echo; echo "See:"
echo "   https://ollama.com/search"
echo "for other models you can download with:"
echo "   ollama pull <model-name>"
echo "Larger models tend to work better."
echo
echo "Models downloaded and available to run:"
ollama list
echo; echo;
echo "Using the $MODEL LLM."
echo; echo

PATH=$PATH:$(go env GOPATH)/bin
mcphost -m ollama:$MODEL --config mcphost-mcp-psql.json
ollama stop $MODEL
