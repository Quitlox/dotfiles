#!/bin/sh

BATTERY_PATH="/sys/class/power_supply/BAT0"

get_capacity() {
	if [ -d "${BATTERY_PATH}" ]; then
		cat "${BATTERY_PATH}/capacity"
	else
		echo 100
	fi
}

has_battery() {
	if [ -d "${BATTERY_PATH}" ]; then
		echo 1
	else
		echo 0
	fi
}

get_charging_status() {
	status=$(cat "${BATTERY_PATH}/status")
	if [ "${status}" = "Charging" ]; then
		echo 1
	else
		echo 0
	fi
}

get_battery_icon() {
	local icon
	if [ "${status}" = "Charging" ]; then
		case $capacity in
		100) icon="󰂅" ;;    # 100%
		9[6-9]) icon="󰂅" ;; # 96-99%
		9[0-5]) icon="󰂋" ;; # 90-95%
		8[0-9]) icon="󰂊" ;; # 80-89%
		7[0-9]) icon="󰢞" ;; # 70-79%
		6[0-9]) icon="󰂉" ;; # 60-69%
		5[0-9]) icon="󰢝" ;; # 50-59%
		4[0-9]) icon="󰂈" ;; # 40-49%
		3[0-9]) icon="󰂇" ;; # 30-39%
		2[0-9]) icon="󰂆" ;; # 20-29%
		1[0-9]) icon="󰢜" ;; # 10-19%
		*) icon="󰢟" ;;      # 0-9%
		esac
	else
		case $capacity in
		100) icon="󰁹" ;;    # 100%
		9[6-9]) icon="󰁹" ;; # 96-99%
		9[0-5]) icon="󰂂" ;; # 90-95%
		8[0-9]) icon="󰂁" ;; # 80-89%
		7[0-9]) icon="󰂀" ;; # 70-79%
		6[0-9]) icon="󰁿" ;; # 60-69%
		5[0-9]) icon="󰁾" ;; # 50-59%
		4[0-9]) icon="󰁽" ;; # 40-49%
		3[0-9]) icon="󰁼" ;; # 30-39%
		2[0-9]) icon="󰁻" ;; # 20-29%
		1[0-9])
			icon="󰁺"
			notify-send -u critical "Battery Low" "Connect Charger"
			;;
		[1-9])
			icon="󰂎"
			notify-send -u critical "Battery Low" "Connect Charger"
			;;
		*) icon="󰂎" ;; # Others, assuming extreme low battery
		esac
	fi
	echo "${icon}"
}

json_output() {
	has_battery=$(has_battery)
	charging_status=$(get_charging_status)
	battery_icon=$(get_battery_icon)
	capacity=$(get_capacity)
	cat <<EOF
{
	"present": ${has_battery},
	"charging": ${charging_status},
	"icon": "${battery_icon}",
	"percent": ${capacity}
}
EOF
}

json_output
exit 0
