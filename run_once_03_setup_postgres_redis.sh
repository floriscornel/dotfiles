#!/bin/bash

if [ ! -d ~/.local/redis/data ]; then
  mkdir -p ~/.local/redis/data
fi

# check if initdb command exists
if ! command -v initdb &> /dev/null; then
  echo "initdb command not found. Please ensure PostgreSQL is installed and in your PATH."
  exit 1
fi

if [ ! -d ~/.local/pgsql/data ]; then
  mkdir -p ~/.local/pgsql/data
  mise exec postgres -- initdb -D ~/.local/pgsql/data -U postgres --no-locale -E UTF8
fi

