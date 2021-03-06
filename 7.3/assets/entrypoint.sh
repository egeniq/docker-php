#!/usr/bin/env bash

# Run composer install now if the source was unavailable during build-time (ie. dev environments).
if [ -f "composer.json" ] && [ ! -d "vendor/composer" ]; then
    echo "Installing composer dependencies..."
    composer install --prefer-dist --no-progress --no-ansi -a -n
fi

exec "$@"
