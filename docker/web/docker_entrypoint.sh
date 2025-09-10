#!/usr/bin/env bash
set -euo pipefail

cd /app

# Check if the app is initialized (Rails app exists)
if [ ! -f "config/application.rb" ]; then
  echo "Rails app not found. Starting bash. Initialize your Rails app manually (e.g., rails new . --database=postgresql)."
  exec bash
fi


if [ -f "package.json" ]; then
  yarn install --frozen-lockfile || yarn install
fi

# Remove server.pid if it exists to prevent Rails server errors
rm -f tmp/pids/server.pid

exec "$@"
