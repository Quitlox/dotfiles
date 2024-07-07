#!/usr/bin/env bash

# Hide ^C
stty -echoctl

########################################
### Check Dependencies
########################################

if ! command -v "sed" &> /dev/null
then
    berror "Missing dependency: 'sed'"
    exit 1
fi

########################################
### Parse Arguments
########################################

POSTITIONAL=()
while [[ $# -gt 0 ]] do
    key="$1"

    case $key in
        *)
            POSTITIONAL+=("$1")
            shift
        ;;
    esac
done

# Check amount of arguments
if (( $(wc -w <<< "$POSTITIONAL") != 1 )); then
    echo "Please provide a single argument!"
    exit 1
fi


