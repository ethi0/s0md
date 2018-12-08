#!/bin/bash
ssh root@$2 ps -A | grep fail2ban | tee $(dirname $0)/fail2ban."$2" > /dev/null 2>&1 
fail=`cat $(dirname $0)/fail2ban."$2"`
if [[ "$fail" != "" ]]
  then echo OK > /dev/null 2>&1
  else echo -e "\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[1;96mFAIL2BAN\e[0m is \e[31mnot running\e[0m on [\e[1;97m$2\e[0m]!" | tee -a $(dirname $0)/report.log
    while true; do 
      read -p "Do you want to start fail2ban?" yn
      case $yn in
    y|"") ssh root@$2 invoke-rc.d fail2ban restart
    break;;
    n|"+") echo -e "\e[33mSKIPPED.\e[0m" | tee -a $(dirname $0)/report.log
    break;;
    *) echo Make your choice!
    break;;
    esac
    done
fi

ssh root@$2 ps -A | grep named | tee $(dirname $0)/named."$2" > /dev/null 2>&1 
named=`cat $(dirname $0)/named."$2"`
if [[ "$named" != "" ]]
  then 
    if [[ "$1" != "1" ]]
      then
      echo -e "\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[33mBIND is running in WDNS-gate\e[0m [\e[1;97m$2\e[0m]!" | tee -a $(dirname $0)/report.log
       while true; do 
               read -p "Do you want to stop bind?" yn
                     case $yn in
                         y|"") ssh root@$2 invoke-rc.d bind9 stop
                             break;;
                         n|"+") echo -e "\e[33mSKIPPED.\e[0m" | tee -a $(dirname $0)/report.log
                             break;;
                          *) echo Make your choice!
                             break;;
                     esac
       done
    else
      echo $2 | tee -a $(dirname $0)/named.log > /dev/null 2>&1
     # ((nb+=1))
    fi
elif [[ "$named" == "" ]]
  then if [[ "$1" == "0" ]]
  then echo OK > /dev/null 2>&1
  else
   echo -e "\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[1;96mBIND\e[0m is \e[33mnot running\e[0m on [\e[1;97m$2\e[0m]." | tee -a $(dirname $0)/report.log
fi
fi

ssh root@$2 ps -A | grep nginx | tee $(dirname $0)/nginx."$2" > /dev/null 2>&1 
nginx=`cat $(dirname $0)/nginx."$2"`
if [[ "$nginx" != "" ]]
    then echo OK > /dev/null 2>&1
      else echo -e "\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[1;96mNGINX\e[0m is \e[31mnot running\e[0m on [\e[1;97m$2\e[0m]!" | tee -a $(dirname $0)/report.log
           while true; do 
            read -p "Do you want to start nginx?" yn
              case $yn in
                y|"") ssh root@$2 invoke-rc.d nginx start
                   break;;
                n|"+") echo -e "\e[33mSKIPPED.\e[0m" | tee -a $(dirname $0)/report.log
                break;;
                *) echo Make your choice!
                   break;;
              esac
            done
fi
