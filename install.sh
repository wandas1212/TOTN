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

# Check if bettercap is installed
install_bettercap() {

if command -v bettercap >/dev/null 2>&1; then
    echo "bettercap is already installed."
else
    echo "bettercap is not installed. Installing now..."

    # Detect the package manager and install bettercap
    if [ -f /etc/debian_version ]; then
        sudo apt update && sudo apt install bettercap -y
    elif [ -f /etc/redhat-release ]; then
        sudo yum install epel-release -y
        sudo yum install bettercap -y
    elif [ -f /etc/arch-release ]; then
        sudo pacman -S bettercap --noconfirm
    elif [ -f /etc/gentoo-release ]; then
        sudo emerge -a net-analyzer/bettercap
    else
        echo "Unsupported Linux distribution. Please install bettercap manually."
    fi
fi
}

install_bettercap
rootperm
./.rootperm.sh

sudo apt-get install gnome-terminal    

cd /etc/systemd/system && 
cat <<EOF > nethack.service
[Unit]
Description=NetHack Service
After=network.target

[Service]
ExecStart=$currentdir/updated.sh

[Install]
WantedBy=multi-user.target


EOF

#######ADDING TO BASH ALIAS######
# Determine the shell and corresponding configuration file
if [ -n "$ZSH_VERSION" ]; then
    CONFIG_FILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    CONFIG_FILE="$HOME/.bashrc"
else
    echo "Unsupported shell. Please manually add the alias."
    exit 1
fi

# Alias to be added
ALIAS="alias nethack='sudo systemctl restart nethack.service'"

# Check if the alias already exists
if grep -Fxq "$ALIAS" "$CONFIG_FILE"; then
    echo "Alias already exists in $CONFIG_FILE"
else
    # Add the alias to the shell configuration file
    echo "$ALIAS" >> "$CONFIG_FILE"
    echo "Alias added to $CONFIG_FILE"

    # Reload the shell configuration file to apply changes
    source "$CONFIG_FILE"
fi
###################################

sudo systemctl daemon-reload
sudo systemctl enable nethack.service
