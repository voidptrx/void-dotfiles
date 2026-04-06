#!/bin/sh

BACKLIGHT="/sys/class/backlight/intel_backlight"
STEP_DELAY=0.5
STEP_SIZE=2

get_profile() {
  hour=$(date +%H)
  if [ "$hour" -ge 20 ] || [ "$hour" -lt 7 ]; then
    echo 10
  elif [ "$hour" -lt 9 ]; then
    echo 35
  elif [ "$hour" -lt 11 ]; then
    echo 50
  elif [ "$hour" -lt 16 ]; then
    echo 70
  elif [ "$hour" -lt 18 ]; then
    echo 90
  else
    echo 35
  fi
}

set_laptop() {
  max=$(cat "$BACKLIGHT/max_brightness")
  echo $((max * $1 / 100)) >"$BACKLIGHT/brightness"
}

get_laptop() {
  max=$(cat "$BACKLIGHT/max_brightness")
  cur=$(cat "$BACKLIGHT/brightness")
  echo $((cur * 100 / max))
}

transition() {
  cur=$1 target=$2 setter=$3
  while [ "$cur" -ne "$target" ]; do
    [ "$cur" -lt "$target" ] && cur=$((cur + STEP_SIZE)) || cur=$((cur - STEP_SIZE))
    [ "$setter" = "laptop" ] && set_laptop "$cur" || ddcutil setvcp 10 "$cur" 2>/dev/null
    sleep $STEP_DELAY
  done
}

last=""
while true; do
  target=$(get_profile)
  if [ "$target" != "$last" ]; then
    transition "$(get_laptop)" "$target" "laptop" &
    transition "$(ddcutil getvcp 10 2>/dev/null | grep -oP 'current value =\s*\K[0-9]+')" "$target" "monitor" &
    wait
    last=$target
  fi
  sleep 60
done
