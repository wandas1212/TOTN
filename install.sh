#!/bin/bash

currentdir=$(pwd)


# Check if the script is run as root
rootperm(){
  if [ "$(id -u)" -ne 0 ]; then
      echo -e "\033[1;91m\n[!] This script must be run as root. ¯\_(ツ)_/¯\n\033[0m"
    exit_msg="\n[++] Shutting down ... Goodbye. ( ^_^)／\n"
    echo -e "$exit_msg"
      exit 1
  fi

}

rootperm

sudo apt-get install gnome-terminal    

cd /etc/systemd/system && 
cat <<EOF > nethack.service
[Unit]
Description=NetHack Service
After=network.target

[Service]
ExecStart=/home/wandas/Desktop/TOTN/update/updated.sh

[Install]
WantedBy=multi-user.target


EOF
