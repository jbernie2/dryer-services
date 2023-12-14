#!/usr/bin/env bash
if [ -z $(printenv | grep "^$2=") ]; then
    echo "Error: missing environment variable $2 in file $1" 1>&2
    exit 1
fi
