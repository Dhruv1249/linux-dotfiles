#!/bin/env bash

CURR_BRIGHTNESS=$(brightnessctl get)
CONFIG_PATH="$HOME/.config/brightnessctl/brightness.txt"

if ! command -v gammastep >/dev/null 2>&1; then
    notify-send "Brightness Script" "gammastep not installed"
    exit 1
fi


# Use integer scale (10 = 1.0, 1 = 0.1)
if [ -f "$CONFIG_PATH" ]; then
  BRIGHTNESS=$(cat "$CONFIG_PATH")
else
  BRIGHTNESS=10
  mkdir -p "$HOME/.config/brightnessctl"
  echo "$BRIGHTNESS" >"$CONFIG_PATH"
fi

# Convert to float for gammastep
to_float() {
  if [ "$1" -le 1 ]; then
    echo "0.1"
  elif [ "$1" -eq 10 ]; then
    echo "1.0"
  else
    echo "0.$1"
  fi
}

if [ "$1" = "+" ]; then
  if [ "$BRIGHTNESS" -eq 10 ]; then
    brightnessctl set $((CURR_BRIGHTNESS + 10))
  else
    BRIGHTNESS=$((BRIGHTNESS + 1))
    [ "$BRIGHTNESS" -gt 10 ] && BRIGHTNESS=10
    pkill gammastep 2>/dev/null
    gammastep -b "$(to_float "$BRIGHTNESS")" -O 6500 &
    echo "$BRIGHTNESS" >"$CONFIG_PATH"
  fi

elif [ "$1" = "-" ]; then
  if [ "$CURR_BRIGHTNESS" -gt 0 ]; then
    NEW=$((CURR_BRIGHTNESS - 10))
    [ "$NEW" -lt 0 ] && NEW=0
    brightnessctl set "$NEW"
  elif [ "$BRIGHTNESS" -gt 1 ]; then
    BRIGHTNESS=$((BRIGHTNESS - 1))
    pkill gammastep 2>/dev/null
    gammastep -b "$(to_float "$BRIGHTNESS")" -O 6500 &

    echo "$BRIGHTNESS" >"$CONFIG_PATH"
  fi

else
  echo "Usage: $0 [+|-]"
  exit 1
fi
