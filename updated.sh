#!/bin/bash
username=$(whoami)
current_dir=$(pwd)
export XAUTHORITY=/home/wandas/.Xauthority
export DISPLAY=:0

#echo $XAUTHORITY
#echo $DISPLAY



is_prompt_shown=false
while true; do
    sleep 2
    #network interfaces
    #up_iface=$(ip -o link show | awk -F': ' '{print $2}' | xargs -I {} sh -c 'ip address show dev {} | grep -q "state UP" && echo {}' | head -n 1)
    up_iface=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^(eth|wl|en|wlp)' | xargs -I {} sh -c 'ip address show dev {} | grep -q "state UP" && echo {}' | head -n 1)


    # Check if any network interface is up
    if [ -n "$up_iface" ]; then
    #bssid=$(iwconfig wlan0 | awk '/Access Point/ {print $NF}')
    
    	#network name
    network_name(){
	if [[ "$up_iface" == *"wl"* ]]; then
    # Wireless interface (Wi-Fi)
    net_name=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2 | tr ' ' '_' || echo "unknown_wifi")
    else
    # Wired interface (Ethernet)
    net_name=$(ip -o -4 addr show $up_iface | awk '{print $4}' | cut -d'/' -f1 | tr ' ' '_' || echo "unknown_ethernet")
    fi
    }
    
    network_name
    
    #net_name=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2 | tr ' ' '_')

        if ! $is_prompt_shown; then
            is_prompt_shown=true
            # Launch a new terminal window
            gnome-terminal -- /bin/bash -c '
            
                while true; do  
                      echo -e "\033[38;5;226m[+]  TAKE OVER THE NETWORK [TOTN] BY WANDAS1212  [+]\n\033[0m"
                      echo -e "\033[38;5;228m[+]  @WANDAS1212 on telegram  [+]\n\033[0m"
                      echo -e "\033[38;5;230m[+]  WANDASHEETS1212@GMAIL.COM [+]\n\033[0m" 
                             
                    # Prompt the user for input
                    read -p "Do you want to hack '$net_name'  network? (y/N): " choice
                    choice=$(echo "$choice" | tr "[:upper:]" "[:lower:]")  # Convert to lowercase

                    if [ "$choice" = "y" ]; then
			cd /home/wandas/Desktop/TOTN && ./test.sh
                        #sleep 3
                    elif [ "$choice" != "n" ]; then
                        # Exit the program
                        echo "
                                            
			_____________________________
                        LETS HACK SOME OTHER TIME!!!
                        	    BYE!!!
			----------------------------
				\   ^__^
				 \  (oo)\_______
				    (__)\       )\/\				
				        ||----w |
					||     ||


                        "
                        sleep 3
                        exit
                    fi

                done
            '
        fi
    else
        is_prompt_shown=false
    fi

    # Wait for 1 second before checking again
    sleep 1
done
