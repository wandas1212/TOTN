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

# check and install packages
check_and_install() {
    local cmd=$1
    local pkg_name=$2

    if command -v $cmd >/dev/null 2>&1; then
        echo "$cmd is already installed."
    else
        echo "$cmd is not installed. Installing now..."

        # Detect the package manager and install the package
        if [ -f /etc/debian_version ]; then
            sudo apt update && sudo apt install $pkg_name -y
        elif [ -f /etc/redhat-release ]; then
            sudo yum install epel-release -y
            sudo yum install $pkg_name -y
        elif [ -f /etc/arch-release ]; then
            sudo pacman -S $pkg_name --noconfirm
        elif [ -f /etc/gentoo-release ]; then
            sudo emerge -a $pkg_name
        else
            echo "Unsupported Linux distribution. Please install $cmd manually."
        fi
    fi
}


rootperm
./.rootperm.sh
# Check and install bettercap
check_and_install "bettercap" "bettercap"

# Check and install gnome-terminal
check_and_install "gnome-terminal" "gnome-terminal"


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

