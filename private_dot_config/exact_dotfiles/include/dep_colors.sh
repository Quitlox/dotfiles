#!/bin/bash

# The following function prints a text using custom color
# -c or --color define the color for the print. See the array colors for the available options.
# -n or --noline directs the system not to print a new line after the content.
# Last argument is the message to be printed.
cecho () {

    declare -A colors;
    colors=(\
        ['black']='\033[0;47m'\
        ['red']='\033[0;31m'\
        ['green']='\033[0;32m'\
        ['yellow']='\033[0;33m'\
        ['blue']='\033[0;34m'\
        ['magenta']='\033[0;35m'\
        ['cyan']='\033[0;36m'\
        ['lgray']='\033[0;37m'\
        ['dgray']='\033[1;30m'\
        ['white']='\033[1;37m'\
        ['bblack']='\033[1;47m'\
        ['bred']='\033[1;31m'\
        ['bgreen']='\033[1;32m'\
        ['byellow']='\033[1;33m'\
        ['bblue']='\033[1;34m'\
        ['bmagenta']='\033[1;35m'\
        ['bcyan']='\033[1;36m'\
        ['bwhite']='\033[1;37m'\
    );

    local defaultMSG="No message passed.";
    local defaultColor="black";
    local defaultNewLine=true;

    while [[ $# -gt 1 ]];
    do
    key="$1";

    case $key in
        -c|--color)
            color="$2";
            shift;
        ;;
        -n|--noline)
            newLine=false;
        ;;
        *)
            # unknown option
        ;;
    esac
    shift;
    done

    message=${1:-$defaultMSG};   # Defaults to default message.
    color=${color:-$defaultColor};   # Defaults to default color, if not specified.
    newLine=${newLine:-$defaultNewLine};

    echo -en "${colors[$color]}";
    echo -en "$message";
    if [ "$newLine" = true ] ; then
        echo;
    fi
    tput sgr0; #  Reset text attributes to normal without clearing screen.

    return;
}

function warning () {
    cecho -c 'yellow' "=> $@";
}
function bwarning () {
    cecho -c 'byellow' "=> ⚠️  $@";
}

function error () {
    cecho -c 'red' "=> $@";
}
function berror () {
    cecho -c 'bred' "=> ⚡ $@";
}

function information () {
    cecho -c 'blue' "=> $@";
}
function binformation () {
    cecho -c 'bblue' "=> ℹ️  $@";
}
function success () {
    cecho -c 'green' "=> $@";
}
function bsuccess () {
    cecho -c 'bgreen' "=> ✅ $@";
}
function debug() {
    cecho -c 'dgray' "$@";
}
