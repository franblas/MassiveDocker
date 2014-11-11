#!/bin/bash

########################################################
# controldock.sh
# Written By Francois Blas
########################################################

#Control command 
black='\e[1;30m';
green='\e[0;32m';
yellow='\e[0;33m';
cyan='\e[0;36m';
noc='\e[0m';

if [[ $1 == "images" ]]; then
	if [[ $2 == "-s" || $2 == "--show" ]]; then
		sudo bash '/home/paco/Desktop/psimages';
	else
		echo '';
		echo "Usage: ./control images [OPTIONS] [arg...]";
		echo '';
		echo 'Options : ';	
		echo "-s, --show : Show all images stored";	
		echo '';
	fi
elif [[ $1 == "containers" ]]; then
	if [[ $2 == "-s" || $2 == "--show" ]]; then
		sudo bash '/home/paco/Desktop/pscontainer';
	elif [[ $2 == "-sa" || $2 == "--stopall" ]]; then
		sudo bash '/home/paco/Desktop/stopcontainer';
	elif [[ $2 == "-ra" || $2 == "--removeall" ]]; then
		sudo bash '/home/paco/Desktop/rmcontainer';
	elif [[ $2 == "-ka" || $2 == "--killall" ]]; then
		sudo bash '/home/paco/Desktop/killcontainer';
	else
		echo '';
		echo "Usage: ./control containers [OPTIONS] [arg...]";
		echo '';
		echo 'Options : ';	
		echo "-s, --show : See all containers";	
		echo "-sa, --stopall : Stop all containers";
		echo "-ka, --killall : Kill all containers";
		echo "-ra, --removeall : Remove all containers stopped";
		echo '';
	fi
else
	echo '';
	echo "Usage: ./control [COMMAND] [OPTIONS] [arg...]";
	echo '';
	echo 'Commands : ';
	echo 'images : Manage images stored';	
	echo 'containers : Manage containers';
	echo '';		
fi
