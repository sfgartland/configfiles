#!/bin/bash

# linkto[laptop]: ~/.config/autostart/mount-fail-notifier.sh

isReadOnly=$(systemctl status media-data.mount | grep -E '[^a-z]ro[^a-z]')


if [[ $isReadOnly ]]; then
	notify-send --urgency=critical '/media/data was mounted as read-only' 'Windows might have shut down without cleaning up'
else
	notify-send 'no-problem'
fi

exit 0
