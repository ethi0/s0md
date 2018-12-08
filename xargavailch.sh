#!/bin/bash
#set -x
echo $3

host=""
   b=`cat /dev/urandom | tr -dc 'a-z' | head -c3`
   s=`dig @1.1.1.1 $b.$3 +short`
   if [[ "$s" != "" ]]
     then
      host=`cat $(dirname $0)/inspect0.list | grep $s | awk -F "_" '{print$2}'`
      if [[ "$1" == "1" ]]
        then
           named=`cat $(dirname $0)/named.log | grep $s`
           if [[ "$named" == $s ]]
             then
             echo $3 >> $(dirname $0)/normal.log
             echo $3,$s >> $(dirname $0)/common.log
           elif [[ "$named" == "" && "$host" == $s ]]
           then 
              echo -e "[\e[1;96m`date | awk '{print$4}'`\e[0m] \e[31mWARNING:\e[0m \e[33mDIG says about\e[0m [\e[1;97m$3\e[0m] and the gate [\e[1;97m$s\e[0m]:" | tee -a $(dirname $0)/report.log
              g=`cat $(dirname $0)/offline.log | grep $s`
                if [[ "$g" == $s ]]
                  then echo -e "\e[33mThe gate is\e[0m \e[31mOFFLINE\e[0m." | tee -a $(dirname $0)/report.log
                  elif [[ "$g" == "" ]]
                  then
              echo -e "\e[1;97ma)\e[0m \e[33mwith bind not started;\e[0m" | tee -a $(dirname $0)/report.log
              echo -e "\e[33mHowever, it's recommended to switch."
              fi
           while true; do
             read -p "Switch? [y|n]" yn
             case $yn in 
             [y]|"") $(dirname $0)/scenaries/switcher.sh $1 $2
           break;;
             [n]|"+"|"\\"|"3") echo -e "\e[33mSKIPPED.\e[0m"
             break;;
             *) echo -e "\e33mMake your choice!"
             break;;
             esac
             done
           
           echo $3 >> $(dirname $0)/normal.log
           echo $3,$s >> $(dirname $0)/common.log
           elif [[ "$host" == "" ]]
                then
              echo -e "[\e[1;96m`date | awk '{print$4}'`\e[0m] \e[31mWARNING:\e[0m \e[33mDomain\e[0m [\e[1;97m$3\e[0m]\e[33m and the gate\e[0m [\e[1;97m$s\e[0m] \e[33mprobably are from another group.\e[0m" | tee -a $(dirname $0)/report.log
              echo $3 >> $(dirname $0)/rooterr0.log
              echo $3 >> $(dirname $0)/suspected.log
              echo $3 >> $(dirname $0)/normal.log
              echo $3,$s >> $(dirname $0)/common.log
           fi
      else
      echo $3 >> $(dirname $0)/normal.log
      echo $3,$s >> $(dirname $0)/common.log
      echo -e "A-note of [\e[1;96m$3\e[0m] is \e[1;97m[\e[31m$s\e[0m\e[1;97m]\e[0m." | tee -a $(dirname $0)/report.log > /dev/null 2>&1
      fi
   elif [[ "$s" == "" ]]
          then
          echo "  - "$3 >> domains.yml && echo $3 >> $(dirname $0)/suspected.log
echo -e "[\e[1;96m`date | awk '{print$4}'`\e[0m] \e[31mERROR:\e[0m [\e[1;96m$3\e[0m] is probably inactive or fake." | tee -a $(dirname $0)/report.log;
echo $3 >> $(dirname $0)/suspected.log
fi
