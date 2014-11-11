#!/bin/bash

#sudo docker run -d -p 49000:80 wnameless/mysql-phpmyadmin
#sudo docker run -d -p 49000:80 -p 49001:22 wnameless/mysql-phpmyadmin

########################################################
# deploy.sh
# Written By Francois Blas
########################################################

#Deploy webserver with web and ssh access (3306 not opened)
port=49000;
port1=49001;
black='\e[1;30m';
green='\e[0;32m';
yellow='\e[0;33m';
cyan='\e[0;36m';
noc='\e[0m';

if [[ $1 == "-n" || $1 == "--number" ]]; then
	if [[ $2 =~ ^-?[0-9]+$ ]]; then
		if (( $2 <= 40 )); then		
			max=$2;
			for ((i=1 ; $max +1 - $i ; i++))
			do num=$(($port+$i)); 
			   num2=$(($port1+$i)); 	
			   dep=$(sudo docker run -d --dns=[8.8.8.8] -p $num:80 -p $num2:22 wnameless/mysql-phpmyadmin 2>&1 | awk '{print $3}');
				while [ ${dep:-a} == "Error:"  ]
				do	#echo "Error : port already used. Trying another one..."; 
					dep=$(sudo docker run -d --dns=[8.8.8.8] -p $port:80 -p $port1:22 wnameless/mysql-phpmyadmin 2>&1 | awk '{print $3}');	
					port=$(($port + 1));	
					port1=$(($port1 + 1));			
				done
	   		   echo -e "${black}webserver${noc} ${yellow}$i${noc} ${cyan}network on${noc} ${green}started${noc}" | column -t ;
			done
		else
			echo "Error : Too much container to launch !";		
		fi	
	else 
		echo "Error : Parameter is not an integer !";	
	fi	
else
	echo '';
	echo "Usage: ./deploy [OPTIONS] [arg...]";
	echo '';
	echo "-n, --number <integer> : Number of containers to deploy";	
	echo '';		
fi
