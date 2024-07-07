#!/usr/bin/env sh

(
  flock 200

  # Let's first kill all running instances
  killall -q polybar

  # Let's wait until the instances are closed
  while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

  # Automatically launch polybar on all monitors
  # Stolen from: https://github.com/polybar/polybar/issues/763
  if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      export MONITOR=$m

      echo "Launching polybar for ${m}"
      polybar -l=trace --reload top </dev/null >/var/tmp/polybar-$m-top.log 2>&1 200>&- &
      polybar -l=trace --reload bottom </dev/null >/var/tmp/polybar-$m-bottom.log 2>&1 200>&- &
      disown
    done
  else
    polybar --reload top &
    polybar --reload bottom &
  fi

) 200>/var/tmp/polybar-launch.lock
