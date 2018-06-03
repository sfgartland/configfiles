#!/usr/bin/env bash

# linkto: /usr/bin/bcon

macAddrRegex="((..:){5}..)"

bluetoothctl power on
index=1


echo "Pairable devices:"
echo "---------------------------"
bluetoothctl devices | sed -E "s/(Device)|$macAddrRegex//g" | while read -r device;do
    echo "[$index] $device"
    (( index++ ))
done


index=0
addrs=()

for macAddr in $(bluetoothctl devices | grep -Eo "$macAddrRegex");do
    addrs[$index]=$macAddr

    (( index++ ))
done

read choice

let index=choice-1

bluetoothctl connect ${addrs[index]}
