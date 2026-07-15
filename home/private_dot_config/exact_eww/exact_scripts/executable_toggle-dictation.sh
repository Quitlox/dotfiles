#!/bin/sh
# Toggle the whole dictation stack: whisper STT + cleanup LLM + OpenWhispr app
w="whisper-server.service"
l="llama-server.service"
app_re='/opt/openwhispr/open-whispr --'
app_bin='/opt/openwhispr/open-whispr'

is_app() { pgrep -f "$app_re" >/dev/null 2>&1; }

# "Fully on" only when all three are up; otherwise a click brings everything up.
if systemctl --user is-active --quiet "$w" && systemctl --user is-active --quiet "$l" && is_app; then
    systemctl --user stop "$l" "$w"
    # SIGTERM the main process (Electron reaps its own renderers). The qdrant
    # sidecar is spawned detached in its own process group, so stop it explicitly.
    pkill -TERM -f "$app_re"
    pkill -TERM -f 'openwhispr/resources/bin/qdrant'
    state="OFF"
else
    systemctl --user start "$w" "$l"
    # Launch OpenWhispr only if not already running (a second launch would just
    # pop its settings window via the single-instance handler)
    if ! is_app; then
        setsid "$app_bin" --no-sandbox >/dev/null 2>&1 &
    fi
    state="ON"
fi

# Immediate widget refresh rather than waiting for the 2s poll
eww update var-dictation="$(~/.config/eww/scripts/dictation-status.sh)" 2>/dev/null

command -v notify-send >/dev/null 2>&1 && \
    notify-send -a "Dictation" "Dictation stack ${state}"
