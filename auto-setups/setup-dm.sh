#!/bin/bash

# Matches packages using start anchor and whitespace at end
hasLightDM=$(yaourt -Q | grep -E "\/lightdm\s")
hasGreeter=$(yaourt -Q | grep -E "\/lightdm-slick-greeter\s")
#hasTheme=$(yaourt -Q | grep -E "\/lightdm-webkit2-theme-material2\s")

if [[ -z $hasLightDM ]]; then
    echo "missing LightDM"
    missingPacs="$missingPacs lightdm"
fi

if [[ -z $hasGreeter ]]; then
    echo "missing  Greeter for LightDM"
    missingPacs="$missingPacs lightdm-slick-greeter"
fi

#if [[ -z $hasTheme ]]; then
#    echo "missing  theme for greeter"
#    missingPacs="$missingPacs lightdm-webkit2-theme-material2"
#fi

# Installs missing packages
if [[ -z $hasLightDM ]] || [[ -z $hasGreeter ]]; then
    yaourt -S $missingPacs
fi

if [[ $(systemctl is-enabled lightdm) = "disabled" ]]; then
    sudo systemctl enable lightdm
fi

if [[ $(systemctl is-enabled lightdm) = "disabled" ]]; then
    printf "Could not enable LightDM\n"
    exit 1
fi

printf "REMEMBER TO LINK GREETER CONFIG!!!!\n"

exit 0
