#!/usr/bin/env bash

# Run composer install now if the source was unavailable during build-time (ie. dev environments).
if [ -f "composer.json" ] && [ ! -d "vendor/composer" ]; then
    echo "Installing composer dependencies..."
    composer install --prefer-dist --no-progress --no-ansi -a -n
fi

php-fpm --fpm-config /usr/local/etc/php-fpm.conf --nodaemonize &
pid1=$!
nginx &
pid2=$!

function kill_child_processes {
    kill -$1 $pid1 $pid2
}

function trap_with_signal() {
    func="$1" ; shift
    for sig ; do
        trap "$func $sig" "$sig"
    done
}

trap_with_signal kill_child_processes SIGHUP SIGINT SIGTERM

wait $pid1 $pid2
