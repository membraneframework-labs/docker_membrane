#!/bin/bash
set -e

# Initialise ASDF
. /root/.asdf/asdf.sh

# Initialize dependecies for OpenGL
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

exec "$@"
