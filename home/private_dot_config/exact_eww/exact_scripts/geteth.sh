#!/bin/bash

# Function to trim leading and trailing whitespace
trim() {
    local var="$1"
    echo "$var" | awk '{$1=$1; print}'
}

# Try using ip command first
INTERFACE=$(ip link show | grep -E '^[0-9]+: [^:]+:' | grep -Eo '^[0-9]+: [^:]+' | cut -d: -f2 | grep -E 'enp|eth' | head -n 1)
INTERFACE=$(trim "$INTERFACE")

if [ -z "$INTERFACE" ]; then
    # Fall back to /sys/class/net
    INTERFACE=$(ls /sys/class/net | grep -E 'enp|eth' | head -n 1)
    INTERFACE=$(trim "$INTERFACE")
fi

if [ -z "$INTERFACE" ]; then
    # Fall back to nmcli
    if command -v nmcli >/dev/null 2>&1; then
        INTERFACE=$(nmcli device status | grep ethernet | awk '{print $1}' | head -n 1)
        INTERFACE=$(trim "$INTERFACE")
    fi
fi

if [ -z "$INTERFACE" ]; then
    echo "no-interface"
    exit 0
fi

# Check if the ethernet is physically connected
if [ -d "/sys/class/net/$INTERFACE" ]; then
    if [[ $(cat /sys/class/net/"$INTERFACE"/carrier) -eq 0 ]]; then
        echo "disconnected"
        exit 0
    fi

    # Optimized internet connectivity check with reduced timeout
    if ping -c 1 -W 1 8.8.8.8 >/dev/null 2>&1; then
        echo "online"
        exit 0
    else
        echo "offline"
        exit 0
    fi
else
    echo "Ethernet interface ${INTERFACE} not found."
    exit 1
fi
