#set -x
countl=`cat $1 | wc -l`
cat $1 | awk -F "," '{print$2}' | sort | uniq >> $(dirname $0)/commonuniq.log
for i in `cat $(dirname $0)/commonuniq.log`; do
  c=`cat $1 | grep ",$i" | wc -l`
  r=`echo $c $countl 100 | awk '{print$1/$2*$3}'`
  echo -e "[\e[1;97m$i\e[0m] \e[33mis\e[0m \e[1;96m$r%\e[0m \e[33mprobable to be a correct A-note.\e[0m"
  echo $i,$r >> $(dirname $0)/anotes
done

rank=`cat $(dirname $0)/anotes | awk -F "," '{print$2}' | sort -nk1 | tail -n1`
cat $(dirname $0)/anotes | grep "$rank" |awk -F "," '{print$1}'| tee $(dirname $0)/anote > /dev/null 2>&1
rankip=`cat $(dirname $0)/anote`
for i in `cat $(dirname $0)/commonuniq.log`; do 
  cat $1 | grep -v $rankip | grep $i | awk -F "," '{print"\033[1;96m["$1"]\033[0m gives [\033[1;97m"$2"\033[0m] \033[0;33mA-note\033[0m"}' | tee -a $(dirname $0)/report.log
done

bh=`cat $(dirname $0)/named.log | wc -l`
ch0=`cat hosts | wc -l`
let ch=ch0-1
if [[ "$bh" -eq $ch ]]
  then
  num=`cat hosts | wc -l`
  num2=`cat $(dirname $0)/named.log | wc -l`
  if [[ "$r" == "100" && "$num" -gt "2" && "$num" == "$num2" ]]
    then echo -e "\e[33mLooks like you have all the gates with bind started where it isn't good. Do you want to STOP it [y|n]? \e[0m"
    while true; do
      read yn
      case $yn in
      y|"") cat hosts |grep -Eo  "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | grep -v $i >  $(dirname $0)/silencer
      for sl in `cat $(dirname $0)/silencer`; do
        ssh root@$sl invoke-rc.d bind9 stop
      done
      break;;
      n|"+") echo -e "\e[33mSKIPPED.\e[0m"
      break;;
      esac
    done
  fi
fi

