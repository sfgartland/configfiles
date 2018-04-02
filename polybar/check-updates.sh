#!/bin/bash

# linkto: ~/.config/polybar/check-updates.sh

echo "Checking for updates..."
echo $(checkupdates | wc -l)" updates pending"

exit 0
