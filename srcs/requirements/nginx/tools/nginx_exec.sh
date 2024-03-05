#!/bin/bash

echo 1
service nginx restart
if [ $? -neq 0 ]; then
    echo fail
    exit 1
fi

# service nginx status 