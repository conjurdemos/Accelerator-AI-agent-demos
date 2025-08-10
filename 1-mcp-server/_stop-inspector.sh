#!/bin/bash
INSP_PIDS=$(ps -ax | grep modelcontextprotocol | grep -v grep | awk '{print $1}')
if [[ "$INSP_PIDS" != "" ]]; then
  for pid in $INSP_PIDS; do
    kill -9 $pid > /dev/null
  done
fi
