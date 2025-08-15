#!/bin/bash

MODEL_DEFAULT=llama3.2:1b

# Start Ollama server
OLLAMA_PID=$(ps -ax | grep "ollama serve" | grep -v grep | awk '{print $1}')
if [[ "$OLLAMA_PID" == "" ]]; then
  nohup ollama serve > ollama.log 2>&1
fi

if [[ "$1" != "" ]]; then
  MODEL=$1
else
  echo "No model name provided on command line, using default $MODEL_DEFAULT."
  MODEL=$MODEL_DEFAULT
fi

echo "Downloading model $MODEL..."
ollama pull $MODEL

echo; echo "See:"
echo "   https://ollama.com/search"
echo
echo "Download other models with:"
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
