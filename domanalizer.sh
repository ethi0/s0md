#set -x
> $(dirname $0)/errdom.log
f=`cat hosts | wc -l`
let m=f-1
> $(dirname $0)/domerr.log
sed '1,8d' $(dirname $0)/enhostdom/dom | tee $(dirname $0)/enhostdom/domcorrect > /dev/null 2>&1
  for dm in $(seq 1 $m); do
      > $(dirname $0)/domdirectory.list."$dm"
      diff $(dirname $0)/enhostdom/domcorrect $(dirname $0)/dom."$dm" | tee $(dirname $0)/errdom0.log > /dev/null 2>&1
      domf=`cat $(dirname $0)/errdom0.log`
      if [[ "$domf" == "" ]]
         then
          echo Good on gate [$dm] > /dev/null 2>&1 
      else 
         let n=dm+1
         gate=`cat hosts | head -n$n | tail -n1`
         echo -e "[\e[1;96m`date | awk '{print$4}'`\e[0m] \e[31mERROR:\e[0m DOM-file is not synchronized on [\e[1;96m$gate\e[0m]." | tee -a $(dirname $0)/report.log | tee $(dirname $0)/errdom.log;
         cat $(dirname $0)/dom."$dm"
      fi  
  done
                                           
  errd=`cat $(dirname $0)/errdom.log`
  if [[ "$errd" == "" ]]
      then 
       echo -e "[\e[1;96m`date | awk '{print$4}'`\e[0m] \e[32mDOM-files are synchronized.\e[0m" | tee -a $(dirname $0)/report.log
  rm $(dirname $0)/errdom.log
  fi

p="$(dirname $0)/additional_dom"
if [ -f "$p" ]
    then
addom=`cat $p`
action=0
if [[ "$addom" != "" ]]
then
for dm in $(seq 1 $m); do
  let n=dm+1
  ip=`cat hosts | head -n$n | tail -n1`
  for dom in `cat $(dirname $0)/master.conf."$dm" | awk -F "_" '{print$2}'`; do
  if [ "$dom" != "dom" ]
      then
      file="$(dirname $0)/"$dom"_"$dm""
      if [ ! -e "$file" ]
        then
   ssh root@$ip cat /var/cache/bind/"$dom" | tee $(dirname $0)/"$dom"_"$dm" > /dev/null 2>&1
  echo $file >> $(dirname $0)/domdirectory.list."$dm"
      fi
 fi
  done
  for domd in `cat $(dirname $0)/domdirectory.list."$dm"`; do
      ipa=`cat $domd | grep "@ IN A" | awk '{print$4}'`
      domdm=`echo $domd | awk -F "/" '{print$2}' | awk -F "_" '{print$1}'`
#      domdm=`echo $domd0 | awk '{}'`
      echo -e "\e[33mWARNING:\e[0m [\e[1;96m$ip\e[0m]\e[33m: Domains\e[0m\e[1;97m\n`cat $(dirname $0)/master.conf."$dm" | grep "_"$domdm"_" | awk -F "_" '{print$1}'`\e[0m\e[33m\nuse dom-file\e[0m\e[1;96m $domdm\e[0m \e[33mwhich gives\e[0m [\e[1;96m$ipa\e[0m]\e[33m as an A-Note\e[0m" | tee -a $(dirname $0)/report.log
      action=1
      for domain in `cat $(dirname $0)/master.conf."$dm" | grep "_"$domdm"_" | awk -F "_" '{print$1}'`; do 
        res=`dig aa."$domain" +short`
        if [[ "$res" != "$ipa" ]]
           then
           echo -ne "\e[31mError!\e[0m  " | tee -a $(dirname $0)/report.log
           action=1
           if [[ "$res" == "" ]]
             then echo -e "[\e[1;97m$domain\e[0m] \e[33mis not working!\e[0m " | tee -a $(dirname $0)/domerr.log | tee -a $(dirname $0)/report.log
             else echo -e "\e[33mA-Note for [\e[0m\e[1;97m$domain\e[0m] is [\e[1;96m$res\e[0m] !" | tee -a $(dirname $0)/domerr.log | tee -a $(dirname $0)/report.log
           fi
        fi
        reslog=`cat $(dirname $0)/domerr.log`
        if [[ "$reslog" == "" ]]
          then 
            echo -e "\e[32mCorrect additional information on gate\e[0m [\e[1;96m$ip\e[0m]." | tee -a $(dirname $0)/report.log
        action=1
        fi
> $(dirname $0)/domerr.log
  done
done
done
fi
fi

if [[ "$action" != "1" && "$addom" != "" ]]
then
echo -e "\e[33mAdditional dom-files are unuseful!\e[0m" | tee -a $(dirname $0)/report.log
fi
