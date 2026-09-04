#!/usr/bin/env bash

options=(
    "LOCK"
    "LOGOUT"
    "RESTART"
    "POWER OFF"
)

chosen=$(printf '%s\n' "${options[@]}" | fuzzel --dmenu --anchor=top-left --hide-prompt --lines=4 --width=12)

# Perform the action based on user choice
case "$chosen" in
    "LOCK") playerctl pause | $HOME/.config/sway/scripts/swaylock-corrupter.sh ;;
    "LOGOUT") swaymsg exit ;;
    "REBOOT") loginctl reboot ;;
    "POWER OFF") loginctl poweroff ;;
    *) exit 1 ;;
esac
