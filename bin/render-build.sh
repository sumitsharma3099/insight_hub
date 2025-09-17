#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Starting build process..."

# Install dependencies
echo "Installing dependencies..."
bundle install

# Precompile assets
echo "Precompiling assets..."
bundle exec rails assets:precompile

# Clean assets
echo "Cleaning assets..."
bundle exec rails assets:clean

# Run database migrations
echo "Running database migrations..."
bundle exec rails db:migrate

echo "Build completed successfully!"
