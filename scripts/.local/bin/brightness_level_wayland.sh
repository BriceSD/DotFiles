#!/bin/bash

# https://aur.archlinux.org/packages/ddcci-driver-linux-dkms#comment-908688
# https://bbs.archlinux.org/viewtopic.php?id=255080
# `ddcutil detect` t know which i2c number

devvideos=$(brightnessctl -l | grep "class 'backlight'" | cut -f '2' -d ' ' | sed "s/'//g")

if [[ $(brightnessctl -d ddcci5) == "Device 'ddcci5' not found" ]]; then
    sudo modprobe ddcci
    sudo modprobe dcci_backlight
    echo 'ddcci 0x37' | sudo tee /sys/bus/i2c/devices/i2c-5/new_device
elif [ ! -d "/dev/bus/ddcci/5" ]; then
    sudo modprobe ddcci
    sudo modprobe dcci_backlight
    echo 'ddcci 0x37' | sudo tee /sys/bus/i2c/devices/i2c-5/new_device
else
    echo "Monitor brightness is already loaded."
    sudo dmesg | rg ddcci
fi

case $1 in
    -) val="U"  ;;
    +) val="A"  ;;
esac
`exec brillo -el -$val 3`
# for devvideo in $devvideos
# do
#     echo $devvideo
#    `exec brightnessctl -d $devvideo s 3%$1 &`
#done
