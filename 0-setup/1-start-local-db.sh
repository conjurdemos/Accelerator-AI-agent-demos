#!/bin/bash

source ../psql-mcp.env

main() {
  pull_psqldb_image
  start_psql_db
  init_db
  echo "Postgres DB is started, initialized, and demo ready."
}

pull_psqldb_image() {
  # see: https://hub.docker.com/_/postgres
  if [[ "$(docker images | grep postgres)" == "" ]]; then
    echo "Pulling PostgreSQL Docker image..."
    case $(uname) in
      Darwin)
        docker pull postgres:15
        ;;
      Linux)
        docker pull postgres:15-bullseye
        ;;
      *)
        echo "Unsupported OS: $(uname)"
        exit -1
    esac
  fi
}

start_psql_db() {
  if [[ "$(docker ps | grep psql-db)" == "" ]]; then
    echo "Starting PostgreSQL DB..."
    docker run -d   \
          --name psql-db \
          -e POSTGRES_PASSWORD=$DB_ADMIN_PASSWORD \
          -p 5432:5432 \
          $PSQL_DB_IMAGE
    echo "PostgreSQL DB started."
  else
    echo "PostgreSQL DB is already running."
  fi
  sleep 3
}

init_db() {
  : <<EOF
  PostgreSQL servers contain a default user named "postgres" that has superuser privileges
  and a default database named "postgres". The script uses the postgres user to create the
  petclinic database.
  Databases contain a default schema named "public" that is created automatically when a
  database is created. Schemas contain tables, views, and other database objects.
  This function creates the petclinic database, loads the initial data, and creates a
  user with full access to the petclinic database tables.
EOF
  echo "Initializing petclinic database..."
  cat db_create_petclinic.sql \
    | psql "host=$DB_HOST \
            user=postgres              \
            password=$DB_ADMIN_PASSWORD"

  cat db_load_petclinic.sql \
    | psql "host=$DB_HOST   \
            user=postgres           \
            password=$DB_ADMIN_PASSWORD \
            dbname=$DB_DATABASE"
  cat db_create_user.sql \
    | sed -e "s/{{DB_USERNAME}}/$DB_USERNAME/g" \
          -e "s/{{DB_PASSWORD}}/$DB_PASSWORD/g" \
    | psql "host=$DB_HOST \
            user=postgres              \
            password=$DB_ADMIN_PASSWORD \
            dbname=$DB_DATABASE"
}

main "$@"
