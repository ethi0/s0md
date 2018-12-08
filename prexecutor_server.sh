#set -x
echo -ne '\e[36m####                                                                                           (10%)\e[0m\r'
echo -e "\e[1;96m[`date`]\e[0m \e[1;97m$4\e[0m is being checked:" >> $(dirname $0)/report.log
echo -e "\n\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[33mChecking hosts...\e[0m\n"
j=2
for i in `cat $(dirname $0)/hosts | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`;
do 
p=`ping -c1 $i | grep -E "unknown | 100% packet loss"`;
 if [[ -z $p ]]
  then
  echo -ne "[\e[1;96m$i\e[0m] is \e[32monline\e[0m. \e[33mChecking container...\e[0m"
  cont=`ssh root@$i ls /floppy | grep distr`
  if [[ "$cont" == "distr" ]]
   then
     echo -e "\e[32mOK.\e[0m"
     echo
     ((j+=1))
  else
    echo
    echo -e "\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[31mERROR:\e[0m Container on \e[1;96m$i\e[0m \e[1mFAIL\e[0m. \e[1;96mExcluding\e[0m from the list." | tee -a $(dirname $0)/report.log
    sed -i "${j}d" $(dirname $0)/hosts
    #break;;
  fi
  else
    echo -e "\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[31mERROR:\e[0m [\e[1;96m$i\e[0m] is \e[31mOFFLINE\e[0m. \e[1;96mExcluding\e[0m from the list." | tee -a $(dirname $0)/report.log
 echo
 sed -i "${j}d" $(dirname $0)/hosts
 fi
done;
tail -n1 $(dirname $0)/hosts | tee $(dirname $0)/anote
echo -ne '\e[36m##########################                                                                     (25%)\e[0m\r'

while true; do
     case $3 in
    1) $(dirname $0)/ex.sh $1 $2
   break;; 
    0) $(dirname $0)/wdnsex.sh $1 $2
    break;;
    *) echo -e "\e[33mPROBLEM?\e[0m"
    break;;
    esac
done
