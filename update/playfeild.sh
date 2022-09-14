#!/bin/bash

sudo arp-scan -l > mac
awk '{ print $2}' mac > MA_only
grep ':' MA_only > ups
rm mac MA_only
mapfile -t array <ups
#rm -rf ups

i=0
len=${#array[@]}
wget -q --spider http://google.com
until [ $? -eq 0 ];
do
    sudo ifconfig wlan0 down && sudo macchanger -m ${array[$i]} wlan0 && sudo ifconfig wlan0 up
    let i++
done



