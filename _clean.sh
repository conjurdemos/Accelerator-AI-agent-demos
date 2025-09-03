#!/bin/bash
source ./psql-mcp.env

DEPTH=2

# Delete named files & directories
rm -rf 	$PGSSLROOTCERT			\
	1-mcp-server/mcp-psql.log	\
	1-mcp-server/mcp-inspector.log	\
	2-self-hosted/ollama.log	\
	4-claude-code/.claude

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
