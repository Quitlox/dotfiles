#!/bin/sh

# Formulas for converting between linear and exponential (e=3) brightness
# >>> def to_perc(val):
# ...     return pow(val / (100 ** -e) / max, 1/e)
# ...
# >>> def to_bright(val):
# ...     return val ** e * max * (100 ** -e)
# ...

brightness_info=$(brightnessctl -m)
brightness_max=$(echo "$brightness_info" | awk -F, '{ print $5 }' | tr -d '%')
brightness_curr=$(echo "$brightness_info" | awk -F, '{ print $3 }' | tr -d '%')

brightness_percent_exp=$(echo "$brightness_info" | awk -F, '{ print $4 }' | tr -d '%')
brightness_percent_linear=$(python -c "print(int(pow($brightness_curr / (100 ** -3) / $brightness_max, 1/3)))")
echo "$brightness_percent_linear"
