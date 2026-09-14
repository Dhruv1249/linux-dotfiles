#!/bin/env bash

CURR_BRIGHTNESS=$(brightnessctl get)
BRIGHTNESS_CONFIG_PATH="$HOME/.config/brightnessctl/brightness.txt"
TEMPEARTURE_CONFIG_PATH="$HOME/.config/brightnessctl/temperature.txt"
DEFAULT_TEMP=4500
DEFAUL_BRIGHT=10

# Notify if gammastep is not installed
if ! command -v gammastep >/dev/null 2>&1; then
    notify-send "Brightness Script" "gammastep not installed"
    exit 1
fi

# Creat config files if not exists
if [ -f "$BRIGHTNESS_CONFIG_PATH" ]; then
    BRIGHTNESS=$(cat "$BRIGHTNESS_CONFIG_PATH")
else
    BRIGHTNESS=10
    mkdir -p "$HOME/.config/brightnessctl"
    echo "$BRIGHTNESS" >"$BRIGHTNESS_CONFIG_PATH"
fi

if [ -f "$TEMPEARTURE_CONFIG_PATH" ]; then
    TEMPERATURE=$(cat "$TEMPEARTURE_CONFIG_PATH")
else
    TEMPERATURE=6500
    mkdir -p "$HOME/.config/brightnessctl"
    echo "$TEMPERATURE" >"$TEMPEARTURE_CONFIG_PATH"
fi

# Use integer scale (10 = 1.0, 1 = 0.1)
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

if [ "$1" = "--init" ]; then
    echo "$DEFAULT_TEMP" > "$TEMPEARTURE_CONFIG_PATH"
    echo "$DEFAUL_BRIGHT" > "$BRIGHTNESS_CONFIG_PATH"
    pkill gammastep 2>/dev/null
    gammastep -b "$(to_float "$DEFAUL_BRIGHT")" -O "$DEFAULT_TEMP" &

elif [ "$1" = "--brightness" ]; then
    if [ "$2" = "+" ]; then
        if [ "$BRIGHTNESS" -eq 10 ]; then
            brightnessctl set $((CURR_BRIGHTNESS + 10))
            gammastep -O "$TEMPERATURE" &
        else
            BRIGHTNESS=$((BRIGHTNESS + 1))
            [ "$BRIGHTNESS" -gt 10 ] && BRIGHTNESS=10
            pkill gammastep 2>/dev/null
            gammastep -b "$(to_float "$BRIGHTNESS")" -O "$TEMPERATURE" &
            echo "$BRIGHTNESS" >"$BRIGHTNESS_CONFIG_PATH"
        fi

    elif [ "$2" = "-" ]; then
        if [ "$CURR_BRIGHTNESS" -gt 0 ]; then
            NEW=$((CURR_BRIGHTNESS - 10))
            [ "$NEW" -lt 0 ] && NEW=0
            brightnessctl set "$NEW"
            gammastep -O "$TEMPERATURE" &
        elif [ "$BRIGHTNESS" -gt 1 ]; then
            BRIGHTNESS=$((BRIGHTNESS - 1))
            pkill gammastep 2>/dev/null
            gammastep -b "$(to_float "$BRIGHTNESS")" -O "$TEMPERATURE" &
            echo "$BRIGHTNESS" >"$BRIGHTNESS_CONFIG_PATH"
        fi
    else
        echo "Usage: $0 $1 [ +|- ]"
    fi

elif [ "$1" = "--temperature" ]; then
    if [ "$2" = "+" ]; then
        TEMPERATURE=$((TEMPERATURE + 500))
        [ "$TEMPERATURE" -gt 6500 ] && TEMPERATURE=6500
        pkill gammastep 2>/dev/null
        gammastep -b "$(to_float "$BRIGHTNESS")" -O "$TEMPERATURE" &
        echo "$TEMPERATURE" >"$TEMPEARTURE_CONFIG_PATH"

    elif [ "$2" = "-" ]; then
        TEMPERATURE=$((TEMPERATURE - 500))
        [ "$TEMPERATURE" -lt 1000 ] && TEMPERATURE=1000
        pkill gammastep 2>/dev/null
        gammastep -b "$(to_float "$BRIGHTNESS")" -O "$TEMPERATURE" &
        echo "$TEMPERATURE" >"$TEMPEARTURE_CONFIG_PATH"
    elif [ "$2" = "--toggle" ]; then
        if [ "$TEMPERATURE" -eq 4500 ]; then
            TEMPERATURE=6500
        elif [ "$TEMPERATURE" -eq 6500 ]; then
            TEMPERATURE=4500
        else
            TEMPERATURE=6500
        fi
        pkill gammastep 2>/dev/null
        gammastep -b "$(to_float "$BRIGHTNESS")" -O "$TEMPERATURE" &
        echo "$TEMPERATURE" >"$TEMPEARTURE_CONFIG_PATH"
    else
        echo "Usage: $0 $1 [ +|- ]"
    fi
else
    echo "Usage: $0 [ --brightness | --temperature ] [ +|- ]"
    exit 1
fi

