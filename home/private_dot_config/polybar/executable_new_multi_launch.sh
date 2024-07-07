#!/bin/bash

source "$HOME/.config/dotfiles/include/dep_colors.sh"

# This script reloads all polybar instances for i3.
# Stolen from: https://github.com/polybar/polybar/issues/763#issuecomment-726872004
debug "Running new_multi_launch.sh"

# Fail if DISPLAY is not set
if [ -z "${DISPLAY}" ] ; then
  echo "DISPLAY not set; must be run from X graphical session."
  exit 1
fi

# Create directories for locks to avoid race conditions
if [ -n "${XDG_CACHE_HOME}" ] ; then
  lock="${XDG_CACHE_HOME}/polybar/bars.at.${DISPLAY}.lock"
  # Create subdirectory for our lock file
  if [ ! -e "$(dirname "${lock}")" ] ; then
    mkdir -p "$(dirname "${lock}")"
  elif [ ! -d "$(dirname "${lock}")" ] ; then
    echo "Lock directory location is not a directory!"
    exit 2
  fi
  echo "${XDG_CACHE_HOME}/polybar/bars.at.${DISPLAY}.lock"
else
  echo "Lock file: /tmp/polybars.at.${DISPLAY}.lock"
  lock="/tmp/polybars.at.${DISPLAY}.lock"
fi

# Initialize log location
if [ -n "${XDG_DATA_HOME}" ] ; then
  logd="${XDG_DATA_HOME}/polybar"
  if [ ! -e "${logd}" ] ; then
    mkdir -p "${logd}"
  elif [ ! -d "${logd}" ] ; then
    echo "Log directory location is not a directory!"
    exit 2
  fi
  echo "${XDG_DATA_HOME}/polybar"
else
  echo "Log file: /tmp"
  logd="/tmp"
fi

# Run this code block
( flock 200
  #---Kill all running polybars on this display
  echo "Killing running polybar instances. (running: $(pgrep 'polybar' | xargs))"
  pgrep 'polybar' | while IFS= read -r _pid ; do
    if [ "${_pid}" != "$$" ] ; then
      # Check the DISPLAY variable of this instance is the same with this one
      #   and terminate that bar if it is
      _dvar="$( \
        ( tr '\0' '\n' | awk -F '=' '/DISPLAY/ {print $2}' ) \
        < "/proc/${_pid}/environ")"
      if [ "${_dvar}" = "${DISPLAY}" ]; then
        kill "${_pid}"
      fi
      # Wait until graceful exit of this instance
      while kill -0 "${_pid}" >/dev/null 2>&1 ; do
        sleep 0.2
      done
    fi
  done
  echo "Killed polybar instances. (running: $(pgrep 'polybar'))"

  #---Get name of primary monitor
  _primon="$(polybar --list-monitors | awk '/primary/ {print substr($1, 1, length($1)-1)}')"
  if [ -z "${_primon}" ] ; then
    _primon="$(polybar --list-monitors | head -n 1 | awk '{print substr($1, 1, length($1)-1)}')"
  fi
  debug "Primary monitor set to $_primon"

  #---Launch polybar on all monitors
  polybar --list-monitors | while IFS= read -r _pom ; do
    #--Format log location
    _mon="$(awk -F '[ ,:]' '{print $1}' <<< "${_pom}")"
    _log="${logd}/log-i3-${DISPLAY}-${_mon}"
    if [ -e "${_log}" ] ; then
      rm --recursive --force "${_log}"
    fi
    export MONITOR="${_mon}"

    #--Get the horizontal resolution to differentiate hidpi
    _hor="$(sed 's|.* \([0-9]\+\)x[0-9]\+.*|\1|' <<< "${_pom}")"
    if [ "${_hor}" -gt '2000' ] ; then
      _suf='-hi'
    else
      _suf=''
    fi

    # Launch the bars
    if [ "${_mon}" = "${_primon}" ]; then
      debug "Launching polybars for $_mon (primary)..."
      # Launch the main bars
      nohup polybar --reload top </dev/null 2>&1 >"${_log}-t" & disown
      nohup polybar --reload bottom </dev/null 2>&1 >"${_log}-b" & disown
    else
      debug "Launching polybars for $_mon..."
      # Launch an auxillary bar
      nohup polybar --reload top </dev/null 2>&1 >"${_log}-t" & disown
      nohup polybar --reload bottom </dev/null 2>&1 >"${_log}-b" & disown
    fi
  done

  # Close the file lock placed
  flock --unlock 200
) 200>"${lock}"
