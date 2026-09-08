#!/usr/bin/env bash

set -euo pipefail

readonly LOCK_SCRIPT="$HOME/.config/sway/scripts/swaylock-corrupter"

options=(
  "suspend"
  "lock"
  "logout"
  "reboot"
  "power off"
)

lock_screen() {
  playerctl pause 2>/dev/null || true
  "$LOCK_SCRIPT"
}

chosen=$(printf '%s\n' "${options[@]}" |
  fuzzel --dmenu --anchor=top-left --hide-prompt \
    --lines="${#options[@]}" --width=11) || exit 0

[[ -z "$chosen" ]] && exit 0

case "$chosen" in
"suspend")
  loginctl suspend
  lock_screen
  ;;
"lock")
  lock_screen
  ;;
"logout")
  swaymsg exit
  ;;
"reboot")
  loginctl reboot
  ;;
"power off")
  loginctl poweroff
  ;;
*)
  exit 1
  ;;
esac
