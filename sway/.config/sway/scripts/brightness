#!/bin/sh

STEP_DELAY=0.1
STEP_SIZE=1

get_profile() {
  hour=$(date +%H)
  case $hour in
  22 | 23 | 00 | 01 | 02 | 03 | 04 | 05 | 06) echo 10 ;;
  07 | 08) echo 35 ;;
  09 | 10) echo 55 ;;
  11 | 12 | 13 | 14 | 15) echo 100 ;;
  16 | 17) echo 90 ;;
  18 | 19) echo 40 ;;
  20) echo 30 ;;
  21) echo 20 ;;
  esac
}

get_laptop() {
  brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
  max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
  echo $((brightness * 100 / max))
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
  cur_laptop=$(get_laptop)
  cur_monitor=$(get_monitor)
  echo "$(date): target=$target last=$last cur_laptop=$cur_laptop cur_monitor=$cur_monitor" >&2

  if [ "$target" != "$last" ] ||
    [ $((cur_laptop - target)) -gt 3 ] || [ $((target - cur_laptop)) -gt 3 ] ||
    { [ -n "$cur_monitor" ] && { [ $((cur_monitor - target)) -gt 3 ] || [ $((target - cur_monitor)) -gt 3 ]; }; }; then
    echo "$(date): triggering transition" >&2
    transition_laptop "$target" &
    transition_monitor "$target" &
    last=$target
  fi
  sleep 300
done
