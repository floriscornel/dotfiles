#!/bin/bash

# check if initdb command exists
if ! command -v initdb &> /dev/null; then
  echo "initdb command not found. Please ensure PostgreSQL is installed and in your PATH."
  exit 1
fi

if [ ! -d ~/.config/pgsql/data ]; then
  mise install -y
  mkdir -p ~/.config/pgsql/data
  initdb -D ~/.config/pgsql/data -U postgres --no-locale -E UTF8
fi