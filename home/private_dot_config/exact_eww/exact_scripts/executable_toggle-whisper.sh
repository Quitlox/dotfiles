#!/bin/sh
# Toggle the whisper.cpp dictation server (systemd user service)
svc="whisper-server.service"

if systemctl --user is-active --quiet "$svc"; then
    systemctl --user stop "$svc"
    state="OFF"
else
    systemctl --user start "$svc"
    state="ON"
fi

# Immediate feedback rather than waiting for the 2s poll
eww update var-whisper="$(systemctl --user is-active "$svc")" 2>/dev/null

command -v notify-send >/dev/null 2>&1 && \
    notify-send -a "Whisper" "Dictation server ${state}"
