#!/bin/sh
# Toggle the whole dictation stack: whisper STT + cleanup LLM
w="whisper-server.service"
l="llama-server.service"

if systemctl --user is-active --quiet "$w" && systemctl --user is-active --quiet "$l"; then
    systemctl --user stop "$l" "$w"
    state="OFF"
else
    systemctl --user start "$w" "$l"
    state="ON"
fi

# Immediate widget refresh rather than waiting for the 2s poll
eww update var-dictation="$(~/.config/eww/scripts/dictation-status.sh)" 2>/dev/null

command -v notify-send >/dev/null 2>&1 && \
    notify-send -a "Dictation" "Dictation stack ${state}"
