#!/bin/sh
# Combined state of the dictation stack for the eww widget:
# whisper STT service + cleanup LLM service + OpenWhispr app.
w=$(systemctl --user is-active whisper-server.service)
l=$(systemctl --user is-active llama-server.service)
pgrep -f '/opt/openwhispr/open-whispr --' >/dev/null 2>&1 && a=active || a=inactive

up=0
[ "$w" = active ] && up=$((up + 1))
[ "$l" = active ] && up=$((up + 1))
[ "$a" = active ] && up=$((up + 1))

if   [ "$up" -eq 3 ]; then echo active
elif [ "$up" -eq 0 ]; then echo inactive
else echo partial
fi
