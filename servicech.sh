#!/bin/bash
#set -x
> $(dirname $0)/errserv.log
> $(dirname $0)/serv.list
> $(dirname $0)/named.log
cat hosts | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | xargs -n1 --max-procs=4 $(dirname $0)/xargservch.sh $1 
nb=`cat $(dirname $0)/named.log | wc -l`
if [[ "$1" == "1" ]]
  then
ch=`cat hosts | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | wc -l`
if [[ "$ch" -eq 4 && "$nb" -lt 2 && "$nb" -gt 0 ]]
  then
  echo -e "\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[33mYou have to\e[0m \e[1;97mstart BIND\e[0m \e[33mon one more gate!\e[0m" | tee -a $(dirname $0)/report.log
  while true; do
    read -p "Do you want to start bind?" yn
    case $yn in
      y|"") while true; do
      read -p "Enter IP: " ip
      ipc=`echo $ip | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
      if [[ "$ipc" != "" ]]
      then
      ipch=`cat hosts | grep $ipc`
      ipok=`cat $(dirname $0)/named.log | grep $ipc`
      if [[ "$ipch" == $ipc && "$ipok" == "" ]]
        then ssh root@$ipch invoke-rc.d bind9 start
        break;
     else echo -e "\e[31mDon't make me stupid!\e[0m"
        fi
        else echo -e "\e[33mNO DATA FOUND!\e[0m"
      fi
      done;
      break;;
      n|"+") echo -e "\e[33mSKIPPED.\e[0m" | tee -a $(dirname $0)/report.log
      break;;
      *) echo Make your choice!
    esac
  done
  elif [[ "$ch" -gt 0 && "$nb" -eq 0 ]]
  then 
  echo -e "\e[31mYOU MUST START BIND ON THE GROUP IMMEDIATELY!\e[0m" | tee -a $(dirname $0)/report.log
  $(dirname $0)/scenaries/switcher.sh $1 $ch
  else
    echo -e "\e[32mServices are OK.\e[0m" > /dev/null 2>&1
fi
fi
