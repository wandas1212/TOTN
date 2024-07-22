#!/bin/bash
export XAUTHORITY=/home/wandas/.Xauthority
export DISPLAY=:0


is_prompt_shown=false
while true; do
    sleep 2
    # Check if the eth0/wlan0 network interface is up
    if ip address show dev wlan0 | grep "state UP" >/dev/null; then
    #bssid=$(iwconfig wlan0 | awk '/Access Point/ {print $NF}')
    net_name=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2 | tr ' ' '_')

        if ! $is_prompt_shown; then
            is_prompt_shown=true
            # Launch a new terminal window
            gnome-terminal -- /bin/bash -c '
            
                while true; do              
                    # Prompt the user for input
                    read -p "Do you want to hack '$net_name'  netowrk? (y/n): " choice
                    choice=$(echo "$choice" | tr "[:upper:]" "[:lower:]")  # Convert to lowercase

                    if [ "$choice" = "y" ]; then
                        cd /home/wandas/Desktop/TOTN/update/ && ./test.sh
                        #sleep 3
                    elif [ "$choice" != "n" ]; then
                        # Exit the program
                        echo "Bye!"
                        sleep 1
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
