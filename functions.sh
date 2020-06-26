#!/bin/bash

# --------------functions-------------------

#If we need to install some packages we do it here.
checkpack() {

#pv package - for fun text display
echo "quering for pv package"
david=$(dpkg --list | grep pv > checker.txt)
check=$(cat checker.txt | grep -i "Shell pipeline element to meter data passing through" | awk '{print $2}')
if [ -z "$check" ];
then
sudo apt-get install pv
echo "---------------------------"
sleep 2
echo "Succefully Installed"
echo "---------------------------"
else
echo "Package: PV is allready installed"
fi

echo "Done questing for packages"

for ((i=1;i<=3;i++));
do
	echo "."
	sleep 1
done

}


#------------------------------SSH Hardening Options display for user---------------------

sshoptions() {

echo "---------------------------------"
echo "SSH - Hardening Options:" | pv -qL 20
echo "(1) - Disable Root SSH login"
echo "(2) - Disconnet Idle Session"
echo "(3) - Change SSH default Port"
echo "(4) - Disable X11Forwarding"
echo "(5) - Change Default Ciphers and Algorithms"
echo "(6) - Enable Scary SSH Banner"
echo "(7) - Change Hostkey Preference"
echo ""
echo ""
echo ""
echo "(777) - Use all settings together"



}

#-----------------------------backing up ssh cfg file---------------------
sshcfgbacup (){	


echo "It is extremly recommended to backup SSH config file"
echo "whould you like to copy it now? (y/n)"
read -p 'Choice: ' copy

while [[ "${copy,,}" != 'y' ]] && [[ "${copy,,}" != 'n' ]] 
do
	echo "Invalid option, please try again"
	sleep 2
	read -p 'Choice: ' copy
done

if [[ "$copy" == 'y' ]]
then
	sudo cp /etc/ssh/sshd_config /etc/ssh/backup.sshd_config
	echo "Backup file created" 
	sleep -3
fi

}
#-----------------------------Loading SSH Defaults---------------------
sshcfgdefaults(){
echo "This script works best on defaults SSH cfg file"
read -p "Would you like to load ssh default script? (y/n)" defcfg
while [[ "${defcfg,,}" != 'y' ]] && [[ "${defcfg,,}" != 'n' ]] 
do
	echo "Invalid option, please try again"
	sleep 2
	read -p 'Choice: ' defcfg
done

if [[ "$defcfg" == 'y' ]]
then
	sudo cp sshd_config /etc/ssh/sshd_config
	echo "Backup file created" 
	sleep 3
fi

}


#check valid port insertion (number only)
#credits https://www.unix.com/shell-programming-and-scripting/17023-validate-number-range.html
numbervalidation () {
read -p "Enter a Port: " port



while true;
do

if echo $port | egrep '^[0-9]+$' >/dev/null 2>&1
then
  if [ $port -ge 1 -a $port -le 65355 ]; then
     echo "OK"
     break
  else
     echo "Out of range"
     read -p "Enter a Port: " port
  fi
else
  echo "Not a number"
  read -p "Enter a Port: " port
fi

done
}

#--------------------------------MAIN SCRIPT OPTIONS FUNCTIONS ------------------------
#-- Option 1--

option1(){
	
	check1=$(cat /etc/ssh/sshd_config | grep -m1 "PermitRootLogin")
	if [[ "$check1" == "PermitRootLogin No" ]]
	then
		echo "Already used! please pick another option"
	else
		sudo sed -i '/.*PermitRootLogin.*/{s//PermitRootLogin No/;:p;n;bp}' /etc/ssh/sshd_config
		sleep 3 
		echo "Disabled root login option"
	fi
}

#-- Option 2--
option2(){
	check2=$(cat /etc/ssh/sshd_config | grep ClientAliveInterval)
	if [[ "$check2" == "ClientAliveInterval 300" ]]
	then
		echo "Already Apllied! please pick another option"
	else
		sudo sed -i '/.*ClientAliveInterval.*/{s//ClientAliveInterval 300/;:p;n;bp}' /etc/ssh/sshd_config
		sudo sed -i '/.*ClientAliveCountMax.*/{s//ClientAliveCountMax 2/;:p;n;bp}' /etc/ssh/sshd_config
	sleep 3 
	echo "Enabled Disocnnect Idle sessions"
	fi
}
#-- Option 3--
option3(){
	numbervalidation
	echo "Chosen Port is $port"
	port="Port ${port}"
	sudo sed -i '/.*Port.*/{s//#Port 22/;:p;n;bp}' /etc/ssh/sshd_config
	sudo sed -i "s/#Port 22/$port/" /etc/ssh/sshd_config
	sleep 3 
	echo "Change default SSH: $port"
}
#-- Option 4--
option4(){
	check4=$(cat /etc/ssh/sshd_config | grep -m1  X11Forwarding)
	if [[ "$check4" == "X11Forwarding no" ]]
	then
		echo "Already Apllied! please pick another option"
	else
	sudo sed -i '/.*11Forwarding.*/{s//X11Forwarding no/;:p;n;bp}' /etc/ssh/sshd_config
	sleep 3 
	echo "Disabled X11Forwarding"
	fi
}

#-- Option 5--
option5(){
	check5=$(sudo cat /etc/ssh/sshd_config | grep -i "kex")
		if [[ "$check5" != "KexAlgorithms curve25519-sha256@libssh.org" ]]
		then
			sudo sed -i '/^# Ciphers and keying/a KexAlgorithms curve25519-sha256@libssh.org' /etc/ssh/sshd_config
			echo "Algorithms Applied"
		else 
			echo "Algorithms already applied!"
		fi
	check51=$(sudo cat /etc/ssh/sshd_config | grep "Ciphers chacha20")
		if [[ "$check51" != "Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr" ]]
		then 
			sudo sed -i '/^# Ciphers and keying/a Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr' /etc/ssh/sshd_config
			echo "Cipher Applied"	
		else
			echo "Cipher Already applied"
		fi
	check52=$(sudo cat /etc/ssh/sshd_config | grep "MACs")
		if [[ "$check52" != "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com" ]]
		then
			sudo sed -i '/^# Ciphers and keying/a MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com' /etc/ssh/sshd_config
		else
			echo "MACs already applied"
		fi
}
#-- Option 6 --
option6(){
	sudo chmod 777 /etc/issue.net 
	sudo echo "	______________________" > /etc/issue.net
	sudo echo "	|                    |" >> /etc/issue.net
	sudo echo "	| Welcome L33t HaX0r |" >> /etc/issue.net
	sudo echo "	| -----BEWARE -------|" >> /etc/issue.net
	sudo echo "	|____________________|" >> /etc/issue.net
    sudo echo "     	   	       ||" >> /etc/issue.net
	sudo echo "		(\_/)  ||" >> /etc/issue.net
	sudo echo "		( *,*) ||" >> /etc/issue.net
	sudo echo "		( )_( )" >> /etc/issue.net
	echo "scary Banner is all SET"
	sleep 2 
}
#-- Option 7 --
option7(){
	line1=$(sudo cat /etc/ssh/sshd_config | grep -m1 "HostKey")
	line2=$(sudo cat /etc/ssh/sshd_config | grep -m2 "HostKey" | grep /etc/ssh/ssh_host_ed25519_key )
	if [[ "$line1" == "HostKey /etc/ssh/ssh_host_rsa_key" ]] && [[ "$line2" == "HostKey /etc/ssh/ssh_host_ed25519_key" ]]
	then
		echo "Already Apllied! please pick another option"
	else
	sudo sed -i "/HostKey/d" /etc/ssh/sshd_config
	sudo sed -i '/^#ListenAddress ::/a HostKey /etc/ssh/ssh_host_ed25519_key' /etc/ssh/sshd_config
	sudo sed -i '/^#ListenAddress ::/a HostKey /etc/ssh/ssh_host_rsa_key' /etc/ssh/sshd_config
	sleep 3 
	echo "Changed Hoskey Preference"
	fi
}
