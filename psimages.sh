#!/bin/bash

########################################################
# psimages.sh
# Written By Francois Blas
########################################################

#Show all images
black='\e[1;30m';
yellow='\e[0;33m';
blue='\e[0;34m';
noc='\e[0m';

tabimagesid=$(docker images -q);
counttab=$(echo $tabimagesid | awk '{print NF}' | sort -nu | tail -n 1);
tabsize=$(docker images | awk '{print $(NF-1)}' | tail -n $counttab);
tabsizee=$(docker images | awk '{print $NF}' | tail -n $counttab);
tabname=$(docker images | awk '{print $1}' | tail -n $counttab);

totalrom=0;

echo "------------------------------------------";
echo -e "${black}NAME${noc} ${yellow}ID${noc} ${blue}SIZE${noc}" | column -t;
echo "------------------------------------------";

for ((i=1 ; $counttab +1 - $i ; i++))
	do id=$(echo $tabimagesid | awk '{print $'$i'}');
	   name=$(echo $tabname | awk '{print $'$i'}');
	   size=$(echo $tabsize | awk '{print $'$i'}');	
	   sizee=$(echo $tabsizee | awk '{print $'$i'}');
		if [ "$sizee" == "B" ]; then
			size=$(echo "$size / 100" | bc);
		elif [ "$sizee" == "GB" ]; then
			size=$(echo "$size * 100" | bc);
		else
			size=$size;
		fi	
	   totalrom=$(echo "$totalrom + $size" | bc);	
	   echo -e "${black}$name${noc} ${yellow}$id${noc} ${blue}$size MB${noc}" | column -t;
done

echo "------------------------------------------" | column -t;
echo -e "${noc}Total ROM : $totalrom MB${noc}" | column -t;
echo "------------------------------------------" | column -t;