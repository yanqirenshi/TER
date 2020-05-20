#!/bin/sh

/bin/bash /var/www/TER/docker/scripts/buid-web-config.sh

nginx -g "daemon off;"
