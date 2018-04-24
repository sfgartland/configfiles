#!/bin/bash

# linkto: ~/remacs.sh

cd ~/.emacs.d
make
systemctl --user restart emacsdaemon
