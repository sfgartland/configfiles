#!/bin/bash

# linkto: ~/.profile

# switch esc and capslock
setxkbmap -option caps:swapescape

export EDITOR="emacsclient -c -t"

# Starts GNOME keychain for terminal applications
# if [ -n "$DESKTOP_SESSION" ]; then
    # eval $(gnome-keyring-daemon --start)
    # export SSH_AUTH_SOCK
# fi
