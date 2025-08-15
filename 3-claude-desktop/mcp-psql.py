# mcp-mysql.py
import os, sys
from fastmcp import FastMCP
from typing import List, Dict, Any
import psycopg2
import subprocess

def _check_env(var: str):
    if not os.environ.get(var):
        print(f"Required env var {var} is not set.", file=sys.stderr)
        sys.exit(-1)
    else:
        return os.getenv(var)

# DEBUG = True wil leak secrets!
DEBUG = False

USER = _check_env("DB_USERNAME")
PASSWORD = _check_env("DB_PASSWORD")
DATABASE = _check_env("DB_DATABASE")
HOST = _check_env("DB_HOST")
PORT = _check_env("DB_PORT")

config = {
    "database": f"{DATABASE}",
    "user": f"{USER}",
    "password": f"{PASSWORD}",
    "host": f"{HOST}",
    "port": f"{PORT}",
}

class DatabaseConnector:
    def __init__(self, config):
        self.connect(config)

    def connect(self, config):
        if DEBUG:
            print("Connecting to the database...", file=sys.stderr)
        try:
            self.connection = psycopg2.connect(**config)
            self.cursor = self.connection.cursor()
        except psycopg2.OperationalError as e:
            print(f"Error connecting to the database: {e}", file=sys.stderr)

    def execute_command(self, command: str) -> str:
        res = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if res.returncode != 0:
            print(f"Error executing command: {res.stderr.decode(sys.stderr.encoding)}")
            return "Command execution failed."
        return res.stdout.decode(sys.stdout.encoding)

    def execute_query(self, query: str) -> List[Dict[str, Any]]:
        if DEBUG:
            print(f"Executing query: {query}", file=sys.stderr)
        self.connect(config)
        self.cursor.execute(query)
        columns = [desc[0] for desc in self.cursor.description]
        results = []
        for row in self.cursor.fetchall():
            results.append({columns[i]: row[i] for i in range(len(columns))})
        return results

mcp = FastMCP("DatabaseTools")
db_connector = DatabaseConnector(config)

@mcp.tool()
def run_db_command(command: str) -> str:
    """Execute a psql database command and return results"""
    cmd_str = f"psql -h {HOST} -U {USER} -w -d {DATABASE} -c \"{command}\""
    try:
        print(f"Executing command: {cmd_str}")
        return db_connector.execute_command(cmd_str)
    except Exception as e:
        print(f"Error executing command: {e}")
        return {"error": str(e)}

@mcp.tool()
def run_sql_query(query: str) -> List[Dict[str, Any]]:
    """Execute an SQL query on the database and return results"""
    try:
        return db_connector.execute_query(query)
    except Exception as e:
        print(f"Error executing query: {e}", file=sys.stderr)
        return {"error": str(e)}


if __name__ == "__main__":
    mcp.run(
        transport="stdio",
    )
