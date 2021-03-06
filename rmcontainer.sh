#!/bin/bash

########################################################
# rmcontainer.sh
# Written By Francois Blas
########################################################

#Remove all containers
black='\e[1;30m';
purple='\e[0;35m';
yellow='\e[0;33m';
noc='\e[0m';

tab=$(docker ps -a -q);
counttab=$(echo $tab | awk '{print NF}' | sort -nu | tail -n 1);

echo "------------------------------------------";
echo -e "${yellow}ID${noc} ${noc}STATE${noc}" | column -t;
echo "------------------------------------------";

for ((i=1 ; $counttab + 1 - $i ; i++))
	do nb=$(echo $tab | awk '{print $'$i'}');
	   dd=$(sudo docker rm $nb);
	   echo -e "${yellow}$nb${noc} ${purple}removed${noc}" | column -t;
done

echo "------------------------------------------";
echo -e "${noc}All containers${noc} ${purple}removed${noc}" | column -t;
echo "------------------------------------------";