#!/bin/bash
BR_FILE="/sys/class/backlight/intel_backlight/brightness"
MAX=$(cat /sys/class/backlight/intel_backlight/max_brightness)
CURRENT=$(cat $BR_FILE)
STEP=106

NEW=$((CURRENT - STEP))
if [ $NEW -lt 0 ]; then
    NEW=0
fi

echo $NEW > $BR_FILE
sleep 0.1
cat $BR_FILE > /dev/null
