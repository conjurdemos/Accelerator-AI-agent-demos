#!/bin/bash
source ../psql-mcp.env

if [[ "$(uname)" != "Darwin" ]]; then
  echo "Claude Desktop demo is only supported on MacOS (requires a GUI)."
  exit -1
fi

if [ ! -d psql-dxt ]; then
  echo "Unzipping compressed extension archive..."
  unzip -q psql-mcp.dxt -d psql-dxt
fi

echo
echo "Generating manifest for desktop extension to reference"
echo "   $DEMO_HOME/psql-mcp.env"
echo "for environment variables."
echo
cd psql-dxt
cat manifest.json.template \
    | sed "s|{{DEMO_HOME}}|$DEMO_HOME|g" \
    > manifest.json
echo "Psql desktop extension is ready for installation in Claude Desktop."
echo
echo "You can download Claude Desktop here: https://claude.ai/download"
echo; echo
