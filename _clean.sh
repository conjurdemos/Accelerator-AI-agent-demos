#!/bin/bash
source ./psql-mcp.env

DEPTH=2

rm -f $PGSSLROOTCERT
rm -f 2-self-hosted/nohup.out
rm -rf 3-claude-desktop/psql-dxt/

LOGDIRS=$(find . -type d -depth $DEPTH | grep logs)
VENVDIRS=$(find . -type d -depth $DEPTH | grep .venv)
LOCKFILES=$(find . -type f -name "*.lock" -depth $DEPTH)

for dir in "$LOGDIRS"; do
  rm -rf $dir
done
for dir in "$VENVDIRS"; do
  rm -rf $dir
done
for file in "$LOCKFILES"; do
  rm -f $file
done
