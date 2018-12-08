#set -x
mon="4.48.158"
err=""

for i in `cat hosts | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; do
  num=`ssh root@$i iptables -nvL --line-numbers | grep $mon | awk '{print$1}'`
  nat=`ssh root@$i iptables -nvL -t nat --line-numbers | grep $mon`

  if [[ "$num" == "" ]]
    then 
      echo OK > /dev/null 2>&1
  elif [[ "$num" != "" ]]
    then
      echo -e "\e[31mERROR:\e[0m \e[1;97mMonitoring\e[0m \e[33mhas been banned on\e[0m [\e[1;97m$i\e[0m]. \e[33mFIXING...\e[0m" | tee -a $(dirname $0)/report.log
      ssh root@$i iptables -D fail2ban-nginx-limit $num > /dev/null 2>&1
      ssh root@$i invoke-rc.d nginx restart > /dev/null 2>&1
  fi
  
  if [[ "$nat" == "" ]]
    then  
      echo OK > /dev/null 2>&1
  elif [[ "$nat" != "" ]]
    then
      echo -e "\e[31mCRITICAL ERROR:\e[0m \e[1;97mMonitoring\e[0m \e[33mhas been banned in '-t nat'-rules on\e[0m [\e[1;97m$i\e[0m]. \e[33mFIX IT YOURSELF!\e[0m" | tee -a $(dirname $0)/report.log
      echo -e "\e[33m$nat\e[0m"
  fi

done
