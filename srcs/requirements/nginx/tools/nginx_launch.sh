#!/bin/bash

tail -f /var/log/nginx/*.log &

nginx -t

sleep infinity
# exec "nginx" "-g" "daemon" "off"

rm -rf tmp/nginx_launch.sh