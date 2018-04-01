#!/bin/bash

# Matches packages using start anchor and whitespace at end
hasLightDM=$(yaourt -Q | grep -E "\/lightdm\s")
hasGreeter=$(yaourt -Q | grep -E "\/lightdm-webkit2-greeter\s")
hasTheme=$(yaourt -Q | grep -E "\/lightdm-webkit2-theme-material2\s")

missingPacs=""

if [[ -z $hasLightDM ]]; then
    echo "missing LightDM"
    missingPacs="$missingPacs lightdm"
fi

if [[ -z $hasGreeter ]]; then
    echo "missing  Greeter for LightDM"
    missingPacs="$missingPacs lightdm-webkit2-greeter"
fi

if [[ -z $hasTheme ]]; then
   echo "missing  theme for greeter"
   missingPacs="$missingPacs lightdm-webkit2-theme-material2"
fi

# Installs missing packages
if [[ $missingPacs != "" ]]; then
    yaourt -S $missingPacs
fi

usePlymouth=""

while [[ $usePlymouth = "" ]]; do
    printf "Use plymouth? (y/n)"
    read usePlymouth
done

if [[ usePlymouth = "y" ]]; then
    serviceName="lightdm-plymouth"
else
    serviceName="lightdm"
fi


if [[ $(systemctl is-enabled $serviceName) = "disabled" ]]; then
    sudo systemctl enable $serviceName
fi

if [[ $(systemctl is-enabled $serviceName) = "disabled" ]]; then
    printf "Could not enable LightDM\n"
    exit 1
fi

printf "REMEMBER TO LINK GREETER CONFIG!!!!\n"

exit 0
