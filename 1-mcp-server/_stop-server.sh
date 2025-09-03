#!/bin/bash
MCP_PIDS=$(ps -ax | grep mcp | grep py$ | grep -v grep | awk '{print $1}')
if [[ "$MCP_PIDS" != "" ]]; then
  for pid in $MCP_PIDS; do
    kill -9 $pid
  done
fi
