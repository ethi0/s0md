#set -x
> $(dirname $0)/ipset.list
f=$2
botsc=`grep "bots" $(dirname $0)/rules/ipset | awk -F "," '{print$2}'`
countrynetsc=`grep "countrynets" $(dirname $0)/rules/ipset | awk -F "," '{print$2}'` 
botnetc=`grep "botnets" $(dirname $0)/rules/ipset | awk -F "," '{print$2}'` 
friendc=`grep "friends" $(dirname $0)/rules/ipset | awk -F "," '{print$2}'` 
#
#if [[ "$1" == "1" || "$1" == "spIPSet" ]] 
   if [[ "$2" == "1" ]]
   then
           echo -e "\n\e[33mThis is an IPSET group!\e[0m"
    echo -ne "[\e[1;96m`date | awk '{print$4}'`\e[0m] \e[33mChecking settings for each host...\e[0m"
for h in `cat hosts | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; 
do
 echo -e "\n$h is being checked for IPSET:" > /dev/null 2>&1
 bots=$( ssh root@$h ipset list -o save bots | grep -v hashsize |wc -l)
 countrynets=$( ssh root@$h ipset list -o save countrynets |grep -v hashsize |wc -l)
 botnets=$( ssh root@$h ipset list -o save botnets |grep -v hashsize |wc -l)
 friends=$( ssh root@$h ipset list -o save friends|grep -v hashsize |wc -l)
 if [[ "$bots" == $botsc && "$countrynets" == $countrynetsc && "$botnets" == $botnetc && "$friends" == $friendc ]]
   then
         echo "GOOD on host $h !" > /dev/null 2>&1
         r="1"
 else
   echo bots[$bots]
   echo countrynets[$countrynets]
   echo botnets[$botnets]
   echo friends[$friends]
   echo
   echo -e "[`date | awk '{print$4}'`] \e[1;31mERROR\e[0m: Bad IPSET on \e[1;36m[$h]\e[0m !" | tee -a $(dirname $0)/report.log
   echo $h >> $(dirname $0)/ipset.list
   r="2"
fi
done;

for j in `cat $(dirname $0)/ipset.list`; do
  echo -e "\e[1;31m\n$j NEED TO REINSTALL IPSET!\e[0m"
  r="2"
done;

if [[ "$r" == "2" ]]
  then
        echo "[gates]" > hosts
        for k in `cat $(dirname $0)/ipset.list`; do
          echo $k >> hosts
        done;
    $(dirname $0)/ipset.sh $1 $2 "inst"
    $(dirname $0)/ipsetcheck.sh $1 $2
    else
      echo -e "\e[32mOK.\e[0m"
      echo -e "\n"
fi;
elif [[ "$2" == "0" ]]
  then
  echo -e "\e[31m\nThis is not an IPSET group!\e[0m"
  echo Eliminating IPSET...
  $(dirname $0)/ipsetkiller.sh 
fi
echo > $(dirname $0)/ipset.list
