#!/bin/bash
source ./psql-mcp.env

DEPTH=2

rm -f 	$PGSSLROOTCERT		\
	1-mcp-server/nohup.out	\
	2-self-hosted/nohup.out
rm -rf 3-claude-desktop/psql-dxt/

LOGDIRS=$(find . -maxdepth $DEPTH -type d | grep logs)
VENVDIRS=$(find . -maxdepth $DEPTH -type d | grep .venv)
LOCKFILES=$(find . -maxdepth $DEPTH -type f -name "*.lock")

for dir in "$LOGDIRS"; do
  rm -rf $dir
done
for dir in "$VENVDIRS"; do
  rm -rf $dir
done
for file in "$LOCKFILES"; do
  rm -f $file
done
