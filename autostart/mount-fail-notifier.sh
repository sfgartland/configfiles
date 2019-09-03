#!/bin/bash

# linkto[laptop]: /bin/mount-fail-notifier.sh

isReadOnly=$(systemctl status media-data.mount | grep -E '[^a-z]ro[^a-z]')


if [[ $isReadOnly ]]; then
	notify-send --urgency=critical '/media/data was mounted as read-only' 'Windows might have shut down without cleaning up'
fi

exit 0
