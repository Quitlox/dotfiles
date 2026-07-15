#!/bin/sh
# Combined state of the dictation stack for the eww widget
w=$(systemctl --user is-active whisper-server.service)
l=$(systemctl --user is-active llama-server.service)
if   [ "$w" = active ] && [ "$l" = active ]; then echo active
elif [ "$w" = active ] || [ "$l" = active ]; then echo partial
else echo inactive
fi
