#!/usr/bin/bash

DEVICE_ID=$(xinput list | sed -n '/Touchpad/s%.*id=\([0-9]\+\).*%\1%p')
ACCEL_SPEED=$(xinput list-props "$DEVICE_ID" | sed -n '/Accel\ Speed\ (/s%.*Accel Speed (\([0-9]\+\)).*%\1%p')
CURR_ACCEL=$(xinput list-props "$DEVICE_ID" | sed -n '/Accel\ Speed\ (/s%.*Accel Speed ([0-9]\+):[[:space:]]*\(.*\)%\1%p')

usage() {
  echo "Enable and disable the touchpad acceleration." >&2
  echo "Usage: $0 [-d|-e]" >&2
  exit 1
}

__disable_accel() {
  xinput set-prop "$DEVICE_ID" "$ACCEL_SPEED" -1
  echo 0
}

__enable_accel() {
  xinput set-prop "$DEVICE_ID" "$ACCEL_SPEED" "$TOUCHPAD_ACCEL_SPEED"
  echo 1
}

# Force
if [ $# -gt 0 ]; then
  mode=$1
  mode="${mode#-}"
  case $mode in
    d | disable) 
    __disable_accel
    exit 0
    ;;
  e | enable)
    __enable_accel
    exit 0
    ;;
  *)
    usage;;
  esac
fi

# Toggle
if (( $(echo "$CURR_ACCEL > -1.0"  | bc -l) )); then
  __disable_accel
else
  if [[ -z "$TOUCHPAD_ACCEL_SPEED" ]]; then
    TOUCHPAD_ACCEL_SPEED=0.6
  fi
  __enable_accel
fi
