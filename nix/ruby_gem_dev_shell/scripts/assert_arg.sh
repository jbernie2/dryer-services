#!/usr/bin/env bash

caller_file=$1
argument_number=$2
argument_description=$3
argument_value=$4

if [ -z $argument_value ]; then
    echo "Error: Argument $argument_number missing when calling $caller_file. Argument should be a $argument_description" 1>&2
    exit 1
fi
