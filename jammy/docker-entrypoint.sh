#!/bin/bash
set -e

# Initialize dependecies for OpenGL
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

exec "$@"
