#!/bin/bash

currentShell=$SHELL

# Aborts script if shell already is fish
if [[ $currentShell = *"fish"* ]]; then
	printf "Current shell is already fish...Exiting\n"
	exit 1
fi

fish=$(chsh -l | grep 'fish')

# If fish isnt installed, install it
if [[ -z "$fish" ]]; then
	printf "Downloading and installing fish...\n"
	sudo pacman -S fish
	fish=$(chsh -l | grep 'fish')
	printf "Installed\n"

else
	printf "Fish is already installed, changing shells...\n"
fi

if [[ -n $fish ]]; then
	# changes shells and checks if success
	if chsh -s $fish | grep "Shell changed." &> /dev/null; then
		printf "Success, changed shells to fish!\n\n"
		printf "Please logout for changes to take effect"
	else
		printf "Couldnt change shell to fish for some reason :(\n"
	fi
else
	printf "Couldnt find fish in your shell list :(\n"
fi

exit 0
