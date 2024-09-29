#!/bin/bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){
    echo -ne "\n${redColour}[!]${endColour} ${grayColour}[+] Exiting...\n${endColour}"
    tput cnorm; airmon-ng stop "${networkCard}mon" > /dev/null 2>&1
    echo -ne "${greenColour}\nThanks for using the tool...\n${endColour}"
    exit 0
}

function banner(){
    echo -ne "${greenColour}▌║█║▌│║▌│║▌║▌█║ Change Your MAC Address ▌│║▌║▌│║║▌█║▌║█${endColour}\n"
    echo -ne "${greenColour}                  by MiguelRega7             ${endColour}\n"
}

function help_panel(){
    banner
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Usage: ./ChangeMAC.sh -i {NameOfYourNetworkCard}${endColour}"
    exit 1
}

function ChangeAddress(){
    echo -e "${yellowColour}[+]${endColour}${grayColour} Changing your MAC Address and Configuring your network card...${endColour}\n"
    airmon-ng start "$networkCard" > /dev/null 2>&1
    ifconfig "${networkCard}mon" down && macchanger -a "${networkCard}mon" > /dev/null 2>&1
    echo -e "${yellowColour}[+]${endColour}${grayColour} Killing unnecessary processes...${endColour}"
    ifconfig "${networkCard}mon" up; killall dhclient wpa_supplicant 2>/dev/null
    echo -e "${yellowColour}[*]${endColour}${grayColour} New MAC Address ${endColour}${purpleColour}[${endColour}${blueColour}$(macchanger -s "${networkCard}mon" | grep -i current | xargs | cut -d ' ' -f 3-)${endColour}${purpleColour}]${endColour}"
}

while getopts ":i:h" arg; do
    case $arg in
        i) networkCard=$OPTARG;;
        h) help_panel;;
        *) help_panel;;
    esac
done

if [ -z "$networkCard" ]; then
    help_panel
fi

if [ "$(id -u)" -eq 0 ]; then
    banner
    ChangeAddress
else
    echo -e "\n${redColour}[+] You have to be root${endColour}\n"
    exit 1
fi
