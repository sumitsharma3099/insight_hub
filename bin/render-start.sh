#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Starting Insight Hub..."

# Wait for database to be ready
echo "Waiting for database connection..."
until bundle exec rails runner "ActiveRecord::Base.connection" 2>/dev/null; do
  echo "Database not ready, waiting..."
  sleep 2
done

echo "Database is ready!"

# Run migrations
echo "Running database migrations..."
bundle exec rails db:migrate

# Start the server
echo "Starting Puma server..."
exec bundle exec puma -C config/puma.rb
