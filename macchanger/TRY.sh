#!/bin/bash
sudo arp-scan -l > 1.txt
sudo arp-scan -l > 2.txt
sudo arp-scan -l > 3.txt
sudo arp-scan -l > 4.txt
tail -n +3 1.txt | head -n -3 > 0.txt && rm 1.txt
tail -n +3 2.txt | head -n -3 > 1.txt && rm 2.txt
tail -n +3 3.txt | head -n -3 > 2.txt && rm 3.txt
tail -n +3 4.txt | head -n -3 > 3.txt && rm 4.txt
awk '{ print $1}' 0.txt 1.txt 2.txt 3.txt > ip.txt
perl -ne 'print unless $dup{$_}++;' ip.txt > ips.txt
rm 0.txt 1.txt 2.txt 3.txt ip.txt


sudo ifconfig wlan0 down && sudo macchanger -m 00:03:2d:29:66:62 wlan0 && sudo ifconfig wlan0 up
cat ips.txt
