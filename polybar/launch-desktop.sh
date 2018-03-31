#!/usr/bin/env sh

# linkto[desktop]: ~/.config/polybar/launch.sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
polybar primary-top &
polybar primary-bottom &

polybar secondary-bottom &


echo "Bars launched..."
