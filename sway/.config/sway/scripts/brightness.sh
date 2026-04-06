#!/bin/sh

STEP_DELAY=0.1
STEP_SIZE=1

get_profile() {
  hour=$(date +%H)
  case $hour in
  20 | 21 | 22 | 23 | 00 | 01 | 02 | 03 | 04 | 05 | 06) echo 10 ;;
  07 | 08) echo 35 ;;
  09 | 10) echo 55 ;;
  11 | 12 | 13 | 14 | 15) echo 85 ;;
  16 | 17) echo 65 ;;
  18 | 19) echo 40 ;;
  *) echo 35 ;;
  esac
}

get_laptop() {
  brightnessctl -m | cut -d, -f4 | tr -d '%'
}

get_monitor() {
  ddcutil getvcp 10 --brief 2>/dev/null | awk '{print $4}'
}

transition_laptop() {
  local target=$1
  cur=$(get_laptop)
  while [ "$cur" -ne "$target" ]; do
    [ "$cur" -lt "$target" ] && cur=$((cur + STEP_SIZE)) || cur=$((cur - STEP_SIZE))
    brightnessctl set "${cur}%" >/dev/null 2>&1
    sleep $STEP_DELAY
  done
}

transition_monitor() {
  local target=$1
  cur=$(get_monitor)
  [ -z "$cur" ] && return

  while [ $((cur - target)) -gt 2 ] || [ $((target - cur)) -gt 2 ]; do
    [ "$cur" -lt "$target" ] && cur=$((cur + 5)) || cur=$((cur - 5))
    ddcutil setvcp 10 "$cur" >/dev/null 2>&1
    sleep 0.5
  done
  ddcutil setvcp 10 "$target" >/dev/null 2>&1
}

last=""
while true; do
  target=$(get_profile)
  if [ "$target" != "$last" ]; then
    transition_laptop "$target" &
    transition_monitor "$target" &
    last=$target
  fi
  sleep 300
done
