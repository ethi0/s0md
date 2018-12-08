#set -x
> $(dirname $0)/rooterr.log
awk '/./' $(dirname $0)/inspect0.list > $(dirname $0)/inspect.list
errd=0
counth=`cat $(dirname $0)/inspect.list | wc -l`
countl=`cat $(dirname $0)/domain | wc -l`
counta=`echo $countl $counth | awk '{print$1*$2}'`
echo -e "\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[33mComparing information: JIRA to ROOT-NSs...\e[0m" 
for l in `ls $(dirname $0)/domains`; do
awk '/./' $(dirname $0)/inspect0.list > $(dirname $0)/inspect.list
awk '/./' $(dirname $0)/domains/"$l" > $(dirname $0)/compare.list
t=`cat $(dirname $0)/domains/"$l" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
if [[ "$t" != "" ]]
then 
rm $(dirname $0)/registrar/"$l"
fi
for s in `cat $(dirname $0)/inspect.list`; do
  for f in `cat $(dirname $0)/compare.list`;do
    if [ $s == "$f" ]
      then
      sed -i "/$s/d" $(dirname $0)/inspect.list
      sed -i "/$s/d" $(dirname $0)/compare.list
      fi
      done
      done
      m=1
      r=`cat $(dirname $0)/inspect.list`
      if [ "$r" != "" ]
        then 
          p=`cat $(dirname $0)/compare.list`
          if [[ "$p" != "" && "$1" == "1" ]]
            then
        echo -e "\e[31mErrors found on\e[0m \e[1;97m$l\e[0m :" | tee -a $(dirname $0)/diff.log | tee -a $(dirname $0)/report.log
        echo $l >> $(dirname $0)/rooterr0.log
        ((err+=1))
        for s in `cat $(dirname $0)/inspect.list`; do
          l=`echo $s | awk -F "_" '{print$1" "$2}'`
          echo -ne "\e[33mJIRA-info\e[0m [\e[1;96m$l\e[0m]" | tee -a $(dirname $0)/report.log
          echo -e " \e[33mTO FACTUAL DATA:\e[0m [\e[1;96m`cat $(dirname $0)/compare.list | head -n$m | tail -n1 | awk -F "_" '{print$1" "$2}'`\e[0m]" | tee -a $(dirname $0)/report.log | tee -a $(dirname $0)/diff2.log
          ((m+=1))
          ((errd+=1))
          done
        fi
      fi
done;


for h in `ls $(dirname $0)/registrar`; do                                                                                                            
  c=`tail -n1 $(dirname $0)/registrar/"$h" | awk -F "." '{print$2"."$3}'`
  if [[ "$c" != "$h" ]]
      then
        if [[ "$c" == "." ]]
          then 
           echo -e "\e[33mDomain\e[0m [\e[31m$h\e[0m] \e[33m is [\e[0m\e[31mlocked / unactivated\e[0m]." | tee -a $(dirname $0)/diff.log | tee -a $(dirname $0)/report.log
           echo $h >> $(dirname $0)/rooterr.log
           ((errd+=$counth))
        else
           echo "Domain $h uses A-Note of registrar $c !" | tee -a $(dirname $0)/report.log
        fi  
  fi
done

if [ $errd != 0 ]
  then
   counterr=`cat $(dirname $0)/diff.log | wc -l`
   r=`echo $countl $counterr | awk '{print$1-$2}'`
   r2=`echo 100 $errd $counta 100 | awk '{print$1-$2/$3*$4}'`
   echo -e "\e[33mJIRA-info is correct for\e[0m \e[1;96m$r\e[0m of \e[1;96m$countl\e[0m domains." | tee -a $(dirname $0)/report.log
   echo -e "\e[33mJIRA-info is correct at\e[0m \e[1;96m$r2%\e[0m generally." | tee -a $(dirname $0)/report.log
elif [ $errd -eq 0 ]
then echo -e "\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[32mAll\e[0m [\e[1;96m$countl\e[0m] \e[32mdomains are actualized.\e[0m" | tee -a $(dirname $0)/report.log
fi
