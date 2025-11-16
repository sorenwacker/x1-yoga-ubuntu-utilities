#!/bin/bash
BR_FILE="/sys/class/backlight/intel_backlight/brightness"
MAX=$(cat /sys/class/backlight/intel_backlight/max_brightness)
CURRENT=$(cat $BR_FILE)
STEP=106

NEW=$((CURRENT + STEP))
if [ $NEW -gt $MAX ]; then
    NEW=$MAX
fi

echo $NEW > $BR_FILE

# Force the watcher to update by sending a signal
WATCHER_PID=$(pgrep -f "icc-brightness-safe watch")
if [ -n "$WATCHER_PID" ]; then
    kill -SIGIO $WATCHER_PID
fi
