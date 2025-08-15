#!/bin/bash
source ../psql-mcp.env
echo "Stopping & removing psql-db..."
docker stop psql-db; docker rm psql-db
