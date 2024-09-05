#!/bin/bash

# Function to get the default interface
get_default_interface() {
    # Using ip route to get the default interface
    ip route | grep '^default' | awk '{print $5}' | head -n 1
}

# Function to get the IP address of the given interface
get_ip_address() {
    local interface="$1"
    ip -4 addr show dev "$interface" | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | head -n 1
}

# Main script logic
INTERFACE=$(get_default_interface)

if [ -z "$INTERFACE" ]; then
    echo "disconnected"
    exit 0
fi

IP_ADDRESS=$(get_ip_address "$INTERFACE")

if [ -z "$IP_ADDRESS" ]; then
    echo "disconnected"
else
    echo "$IP_ADDRESS"
fi
