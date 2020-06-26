#!/bin/bash

#Description: This script is for linux system only
#Purpose: SSH Hardening with various methods 
#Running: this script requires SUDO + execute permission by the running user
#Author: excoRt





#loading functions file

source ./functions.sh

#quering for necessary packges

echo "quering for required packges"
for ((i=1;i<=3;i++));
do
	echo "."
	sleep 1
done
checkpack


#Main hardeing script"

#Intro
figlet "SSH - Hardening"
sleep 2
echo "This script is intended for ubuntu linux system only" | pv -qL 18

#loading defaults?
sshcfgdefaults

#calling func: backing up ssh cfg file?
sshcfgbacup


#main script
choice=$(echo "start")

while [[ "$choice" != "q" ]]
do

sshoptions

echo "Please provide a choice number | type 'q' to exit"

read -p 'Choice: ' choice

while [[ "${choice,,}" != '1' ]] &&
		[[ "${choice,,}" != '2' ]] &&
		 [[ "${choice,,}" != '3' ]] &&
		  [[ "${choice,,}" != '4' ]] &&
		  [[ "${choice,,}" != '5' ]] && 
		  [[ "${choice,,}" != '6' ]] && 
		  [[ "${choice,,}" != '7' ]] && 
		  [[ "${choice,,}" != '777' ]] &&
		  [[ "${choice,,}" != '8' ]] && 
		  [[ "${choice,,}" != '9' ]] && 
		  [[ "${choice,,}" != '999' ]] && 
		   [[ "${choice,,}" != 'q' ]] 
do
	echo "Invalid option, please try again"
	sleep 2
	read -p 'Choice: ' choice
done

if [ "$choice" == "1" ]
then
	option1
fi

if [ "$choice" == "2" ]
then
	option2
fi

if [ "$choice" == "3" ]
then
	option3
fi

if [ "$choice" == "4" ]
then
	option4
fi

if [ "$choice" == "5" ]
then
	option5
fi

if [ "$choice" == "6" ]
then
	option6

fi

if [ "$choice" == "7" ]
then
	option7

fi

if [ "$choice" == "8" ]
then
	option8

fi

if [ "$choice" == "9" ]
then
	option9
fi

if [ "$choice" == "999" ]
then
	cat man.txt
fi

if [ "$choice" == "777" ]
then
	option1
	option2
	option3
	option4
	option5
	option6
	option7

fi

if [ "$choice" == "q" ]
then
	echo "Restarting SSH servrice to apply changes"
	sudo systemctl restart ssh
	sleep 3 

fi

done






















