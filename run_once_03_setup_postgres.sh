#!/bin/bash
if [ ! -d ~/.config/pgsql/data ]; then
  mkdir -p ~/.config/pgsql/data
  initdb -D ~/.config/pgsql/data -U postgres --no-locale -E UTF8
fi