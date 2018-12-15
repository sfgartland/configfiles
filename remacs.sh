#!/bin/bash

# linkto: /usr/bin/remacs

#This file generates a command to auto
#load and restart emacs daemon

cd ~/.emacs.d
#make install
systemctl --user restart emacsdaemon
