#> $(dirname $0)/unsynchronized.log

if [ -f "$2" ]
  then
m=`cat hosts | wc -l`
((m-=1))
#echo Checking bind and nginx configuration files for unsynchronized domains.
if [[ $1 == "1" ]]
then
for v in $(seq 1 $m); do
for i in `cat $2 |awk -F "," '{print$1}'`; do
  mst=`cat $(dirname $0)/master.conf."$v" | grep "$i"`
  nx=`cat $(dirname $0)/nginx.conf."$v" | grep "$i"`
  if [[ "$mst" != "" && "$nx" != "" ]]
    then
    echo Good $i on gate [$v] > /dev/null 2>&1
  else
    let n=v+1
    gate=`cat hosts | head -n$n | tail -n1`
    echo -e "[\e[1;96m`date | awk '{print$4}'`\e[0m] \e[31mERROR:\e[0m [\e[1;96m$i\e[0m] is not synchronized on [\e[1;96m$gate\e[0m]." | tee -a $(dirname $0)/report.log;
    echo $i >> $(dirname $0)/unsynchronized.log
  fi
#  ((v+=1))
done
done

elif [[ $1 == "0" ]]
then
#added awk -F
for v in $(seq 1 $m); do
  for i in `cat $2 | awk -F "," '{print$1}'`; do
        nx=`cat $(dirname $0)/nginx.conf."$v" | grep "$i"`
   if [[ "$nx" != "" ]]
     then
  echo Good $i on gate [$v] > /dev/null 2>&1
else
 let n=v+1
 gate=`cat hosts | head -n$n | tail -n1`
 echo -e "[\e[1;96m`date | awk '{print$4}'`\e[0m] \e[31mERROR:\e[0m [\e[1;96m$i\e[0m] is not synchronized on [\e[1;96m$gate\e[0m]." | tee -a $(dirname $0)/report.log;
 echo $i >> $(dirname $0)/unsynchronized.log
fi
#((v+=1))
  done
done
fi

if [ -f "$(dirname $0)/unsynchronized.log" ]
  then
u=`cat $(dirname $0)/unsynchronized.log`
 if [[ "$u" == "" ]]
   then
echo -e "[\e[1;96m`date | awk '{print$4}'`\e[0m] \e[32mAll DOMAINS are SYNCHRONIZED.\e[0m" | tee -a $(dirname $0)/report.log
 fi
fi
    else echo "Skipped checking $2".
fi
