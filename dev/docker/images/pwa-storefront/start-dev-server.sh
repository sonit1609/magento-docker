#!/bin/bash
set -e

# Build design css
yarn design:build

# Install node modules
yarn install

# Start dev server
if [ -f .docker-backend-ready ]; then
    yarn watch:docker || true
else
    echo "Backend hasn't been ready or missing file .docker-backend-ready"
    bash # Prevent container auto restart
fi
