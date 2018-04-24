#!/bin/sh

# linkto: ~/.config/polybar/check-mail.sh

echo $(notmuch count tag:unread)" unread mail"

exit 0
