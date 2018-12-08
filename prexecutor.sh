#set -x
> $(dirname $0)/normal.log
> $(dirname $0)/suspected.log
> $(dirname $0)/normalext.log
echo "---" > domains.yml
echo "domains:" >> domains.yml
> $(dirname $0)/domain
> $(dirname $0)/errhost.log
> $(dirname $0)/offline.log
echo -ne '\e[36m####                                                                                           (10%)\e[0m\r'


echo -ne "\n\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[33mChecking hosts...\e[0m"
j=2
for i in `cat hosts | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`;
do 
p=`ping -c1 $i | grep -E "unknown | 100% packet loss" &`;
 if [[ -z $p ]]
  then
    cont=`ssh root@$i ls /floppy | grep distr`
    if [[ "$cont" == "distr" ]]
      then
     ((j+=1))
    else
      echo
      echo -e "\n\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[31mERROR:\e[0m Container on \e[1;96m$i\e[0m \e[1mFAIL\e[0m. \e[1;96mExcluding\e[0m from the list." | tee -a $(dirname $0)/report.log | tee $(dirname $0)/errhost.log
      echo
      ssh root@$i uptime | tee -a $(dirname $0)/report.log
      echo -e "\e[33m"
      while true; do
      read -p "Do you want to install a container [y|n|IGNORE]? " yn
      echo -e "\e[0m"
        case $yn in
        y|"") ssh root@$i losetup -f /var/crash/httpd.core
          echo -e "\e[33mEnter container password: "
          ssh root@$i cryptsetup create floppy /dev/loop0
          ssh root@$i mount -o noatime,nodiratime /dev/mapper/floppy /floppy
          echo -e "\e[33m"
          while true; do
          read -p "[r]unipt or [s]etupipt? " rs
          case $rs in
          r)  ssh root@$i /floppy/distr/runipt.sh
             ssh root@$i invoke-rc.d nginx reload
            read -p "Start/Stop bind [y|n]? " YN
            echo -e "\e[0m"
            while true; do
            case $YN in
            y|"")  ssh root@$i invoke-rc.d bind9 start
              break;;
            n|"+")  ssh root@$i invoke-rc.d bind9 stop
              break;;
            *) echo Make your choice!;;
          esac
          done
        break;;
          s)  ssh root@$i /floppy/distr/setupipt.sh
             ssh root@$i invoke-rc.d nginx reload
             ssh root@$i invoke-rc.d bind9 stop
            echo -e "Now you have to add domains there: [\e[1;97m$i\e[0m]" 
            echo Continue...
            break;;
          *) echo Make your choice!;;
          
          esac
          done
          break;;
        n|"+") 
          echo -e "Container installation refused. Excluding from the list."
          sed -i "${j}d" hosts
          echo $i >> $(dirname $0)/offline.log
          break;;
        "IGNORE") echo -e "\n\e[1;96m[`date`]\e[0m \e[31mIGNORED MISSING CONTAINER.\e[0m [\e[1;97m$i\e[0m]" | tee -a $(dirname $0)/report.log | tee -a $(dirname $0)/enhostdom/alert_report.log
          break;;
          *) echo "Make your choice!";;
        esac
        done
     fi
  else
    echo -e "\n\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[31mERROR:\e[0m [\e[1;96m$i\e[0m] is \e[31mOFFLINE\e[0m. \e[1;96mExcluding\e[0m from the list." | tee -a $(dirname $0)/report.log | tee -a $(dirname $0)/errhost.log
    echo $i >> $(dirname $0)/offline.log;
    sed -i "${j}d" hosts
 fi
done;
wait
errh=`cat $(dirname $0)/errhost.log`
if [[ "$errh" == "" ]]
  then 
  echo -ne "\e[32mOK.\e[0m"
fi

echo -ne '\n\e[36m##########################                                                                     (25%)\e[0m\r'

qh0=`cat hosts | wc -l`
let qh=qh0-1
while true; do
  case $3 in
# $3 = W/DNS
# $2 = QOH 
# $ = IPSET
1) $(dirname $0)/scenaries/dnscheck.sh $3 $2
break;;
0) $(dirname $0)/scenaries/wdnscheck.sh $3 $2
break;;
S) $(dirname $0)/scenaries/switcher.sh 1 $qh
break;;
W) $(dirname $0)/scenaries/addom.sh $4
break;;
D) $(dirname $0)/scenaries/domdel.sh 
break;;
SP) $(dirname $0)/scenaries/spider.sh
break;;
*) echo "PROBLEM?";;
esac
done
