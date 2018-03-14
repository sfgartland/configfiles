#!/bin/bash

# Only starts chrome if it isnt already running
if ! pgrep -x "chrome" > /dev/null 2>&1
then
    exec google-chrome-stable
fi
