#!/bin/bash

########################################################
# killcontainer.sh
# Written By Francois Blas
########################################################

#Kill all containers
black='\e[1;30m';
red='\e[0;31m';
yellow='\e[0;33m';
noc='\e[0m';

tab=$(docker ps -a -q);
counttab=$(echo $tab | awk '{print NF}' | sort -nu | tail -n 1);

echo "------------------------------------------";
echo -e "${yellow}ID${noc} ${noc}STATE${noc}" | column -t;
echo "------------------------------------------";

for ((i=1 ; $counttab + 1 - $i ; i++))
	do nb=$(echo $tab | awk '{print $'$i'}');
	   dd=$(sudo docker kill $nb);
	   echo -e "${yellow}$nb${noc} ${red}killed${noc}" | column -t;
done

echo "------------------------------------------";
echo -e "${noc}All containers${noc} ${red}killed${noc}" | column -t;
echo "------------------------------------------";