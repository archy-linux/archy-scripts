#!/usr/bin/bash

DEVICE_ID=$(xinput list | sed -n '/Touchpad/s%.*id=\([0-9]\+\).*%\1%p')
ACCEL_SPEED=$(xinput list-props "$DEVICE_ID" | sed -n '/Accel\ Speed\ (/s%.*Accel Speed (\([0-9]\+\)).*%\1%p')
CURR_ACCEL=$(xinput list-props "$DEVICE_ID" | sed -n '/Accel\ Speed\ (/s%.*Accel Speed ([0-9]\+):[[:space:]]*\(.*\)%\1%p')

if (( $(echo "$CURR_ACCEL > -1.0"  | bc -l) )); then
  xinput set-prop "$DEVICE_ID" "$ACCEL_SPEED" -1
  echo 0
else
  if [[ -z "$TOUCHPAD_ACCEL_SPEED" ]]; then
    TOUCHPAD_ACCEL_SPEED=0.6
  fi
  xinput set-prop "$DEVICE_ID" "$ACCEL_SPEED" "$TOUCHPAD_ACCEL_SPEED"
  echo 1
fi
