#!/bin/bash

# linkto: ~/.config/polybar/bluetooth.sh

echo $(bluetoothctl info | grep Name | sed -E "s/\tName: //")
