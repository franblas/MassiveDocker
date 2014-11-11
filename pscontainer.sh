#!/bin/bash

########################################################
# pscontainer.sh
# Written By Francois Blas
########################################################

#Show all containers
black='\e[1;30m';
red='\e[0;31m';
green='\e[0;32m';
yellow='\e[0;33m';
blue='\e[0;34m';
cyan='\e[0;36m';
noc='\e[0m';

tabrun=$(docker ps -q);
counttabrun=$(echo $tabrun | awk '{print NF}' | sort -nu | tail -n 1);
tabrunallid=$(docker ps -a -q);
counttab=$(echo $tabrunallid | awk '{print NF}' | sort -nu | tail -n 1);
counttabnotrun=$(($counttab - $counttabrun));
tabrunall=$(docker ps -a);
tabstatus=$(docker ps -a | awk '{print $7}' | tail -n $counttab);
tabsize=$(docker ps -a -s | awk '{print $(NF-1)}' | tail -n $counttab);
tabsizee=$(docker ps -a -s | awk '{print $NF}' | tail -n $counttab);
tabimages=$(docker ps -a | awk '{print $2}' | cut -d ':' -f1 | tail -n $counttab);
tabcommands=$(docker ps -a | awk '{print $3}' | tail -n $counttab);
ports="none";

totalrom=0;
totalram=0;
totalram2=0;

echo "------------------------------------------" | column -t;
echo -e "${black}IMAGE${noc} ${yellow}ID${noc} ${blue}ROM${noc} ${blue}RAM${noc} ${cyan}NETWORK${noc} ${noc}STATE${noc}" | column -t;
echo "------------------------------------------" | column -t;

for ((i=1 ; $counttab +1 - $i ; i++))
	do id=$(echo $tabrunallid | awk '{print $'$i'}');
	   image=$(echo $tabimages | awk '{print $'$i'}');
	   status=$(docker ps -a | grep $id | grep Up);
	   size=$(echo $tabsize | awk '{print $'$i'}');
	   sizee=$(echo $tabsizee | awk '{print $'$i'}');
	
		if [ "$sizee" == "B" ]; then
			size=$(echo "$size / 100" | bc);
		elif [ "$sizee" == "GB" ]; then
			size=$(echo "$size * 100" | bc);
		else
			size=$size;
		fi

		if [ "$status" == "" ]; then
			sizeram=0;
			totalram=$(($totalram + 0));			
			echo -e "${black}$image${noc} ${yellow}$id${noc} ${blue}$size MB${noc} ${blue}$sizeram KB${noc} ${cyan}$ports${noc} ${red}stopped${noc}" | column -t;
		else	
			port1=$(docker ps -a | grep $id | grep tcp | awk '{print $(NF - 1)}');
			port2=$(docker ps -a | grep $id | grep tcp | awk '{print $(NF - 2)}');
			port3=$(docker ps -a | grep $id | grep tcp | awk '{print $(NF - 3)}');
			portss="$port3 $port2 $port1";	
			command=$(echo $tabcommands | awk '{print $'$i'}');
			pssbis=$(ps aux | grep $image | grep $command | awk '{print $6}');
			pss=$(ps aux | grep $image | grep $command | awk '{print $5}');
				if [ "$pss" == "" ]; then
					tabcommands2=$(docker ps -a | awk '{print $4}' | tail -n $counttab);
					command2=$(echo $tabcommands2 | awk '{print $'$i'}');
					pss=$(ps aux | grep "$command $command2" | awk '{print $5}');
					pssbis=$(ps aux | grep "$command $command2" | awk '{print $6}');
				fi
			sizeram=$(echo $pssbis | awk '{print $1}');
			sizeram2=$(echo $pss | awk '{print $1}');
			totalram=$(($totalram + $sizeram));
		        totalram2=$(($totalram2 + $sizeram2));
			echo -e "${black}$image${noc} ${yellow}$id${noc} ${blue}$size MB${noc} ${blue}$sizeram/$sizeram2 KB${noc} ${cyan}$portss${noc} ${green}running${noc}" | column -t ;
		fi

	   totalrom=$(echo "$totalrom + $size" | bc);
	   	   
done

totalram=$(echo "$totalram / 100" | bc);
totalram2=$(echo "$totalram2 / 100" | bc);

echo "------------------------------------------" | column -t;
echo -e "${noc}Total ROM : $totalrom MB${noc}" | column -t;
echo -e "${noc}Total RAM : $totalram/$totalram2 MB${noc}" | column -t;
echo -e "${noc}Total containers : $counttab${noc}" | column -t;
echo -e "${noc}$counttabrun containers running${noc}" | column -t;
echo -e "${noc}$counttabnotrun containers stopped${noc}" | column -t;
echo "------------------------------------------" | column -t;