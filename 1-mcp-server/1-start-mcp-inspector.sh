#!/bin/bash
if [[ "$(uname)" == "Linux" ]]; then
  echo "MCP Inspector only works on MacOS"
  exit -1
fi

echo "Killing any running inspector..."
INSP_PIDS=$(ps -ax | grep modelcontextprotocol | grep -v grep | awk '{print $1}')
if [[ "$INSP_PIDS" != "" ]]; then
  for pid in $INSP_PIDS; do
    kill -9 $pid
  done
fi
mkdir -p logs
npx @modelcontextprotocol/inspector 2>&1 > logs/mcpinspector.log &
