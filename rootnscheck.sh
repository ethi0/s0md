#!/bin/bash
#set -x

j=$(echo $1 | grep -E -o "\.\w{1,}")
ja=$(echo $j | awk -F "." '{print$2"."}')
rootns=$(cat $(dirname $0)/rules/rootnss | grep "$j" | awk -F ", " '{print$2}')

raw_digcheck(){
echo -e "\e[33mA-note + NSs (probably registrars'):\e[0m"
dig $1 | grep A | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}"| awk '{print$1$5}' | awk -F "." '{print$1i"_"$(NF-3)"."$(NF-2)"."$(NF-1)"."$(NF)}'| tee -a $(dirname $0)/domains/"$1" > /dev/null 2>&1
}

root_check(){
dig @$2 $1 | grep ns | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}"| awk '{print$1$5}' | awk -F "." '{print$1i"_"$(NF-3)"."$(NF-2)"."$(NF-1)"."$(NF)}'| tee -a $(dirname $0)/domains/"$1" > /dev/null 2>&1
dig @$2 $1 | grep ns | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}"| awk '{print$1$5}' | awk -F "." '{print$1i"_"$(NF-3)"."$(NF-2)"."$(NF-1)"."$(NF)}'| tee $(dirname $0)/registrar/"$1" > /dev/null 2>&1
}


if [ "$rootns" != "" ]
then
	root_check $1 $rootns
else
	echo -e "\e[33mDont know NameServer for\e[0m [\e[31m$1\e[0m]" | tee -a $(dirname $0)/report.log
	echo -e "\e[33mTrying to retrieve information anyway...\e[0m"
	rootnstrc=$(dig $1 +trace | grep "$ja" | awk '{print$5}' | head -n3 | tail -n1 | sed 's/^\(.*\).$/\1/')
	echo -e "\e[33mAdding new rootNS to the database...\e[0m"
	echo -e "$j|", $rootnstrc >> $(dirname $0)/rules/rootnss
	echo -e "\e[33mVariant 1:\e[0m"
	root_check $1 $rootnstrc
	echo -e "\e[33mVariant 2:\e[0m"
	raw_digcheck $1
fi
