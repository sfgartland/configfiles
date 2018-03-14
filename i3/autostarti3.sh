#!/bin/bash

# Only starts chrome if it isnt already running
if ! pgrep -x $1 > /dev/null 2>&1
then
    exec $2
fi
