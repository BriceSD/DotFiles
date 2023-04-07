#!/bin/bash

# sputnick.fr 2023

devvideos=$(xrandr | grep -w connected | cut -f '1' -d ' ')

if ! val=$(cat ~/.config/xrandr/brightness 2>/dev/null); then
    mkdir -p ~/.config/xrandr
    echo 0.90 > ~/.config/xrandr/brightness
    val=0.90
fi

case $1 in
    -) val="0$(bc <<< $val-0.05)"  ;;
    +) val="0$(bc <<< $val+0.05)"  ;;
esac


echo $val | tee ~/.config/xrandr/brightness 
for devvideo in $devvideos
do
   `exec xrandr --output $devvideo --brightness +$val &`
done
