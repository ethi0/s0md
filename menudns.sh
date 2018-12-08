#set -x
while true; do
 echo -e "\e[33mDo you want to: "
 echo -e "DELETE invalid [d]omains /" 
 echo -e "DELETE locked/unactivated domains[dd] /"
 echo -e "DELETE OTHER GRs' domains[df] /"
 echo -e "SYNCHRONIZE [s]ettings /"
 echo -e "MIRROR A-gate[m] /"
 echo -e "ADD [u]nlisted domains /"
 echo -e "SHOW unchanged domains [su] /"
echo -e "just CONTINUE checking (Enter) / [e]xit?\e[0m "
echo -e "\e[31mPLEASE NOTE:\e[0m \e[33mIf you are not sure, to SYNC or MIRROR, choose MIRROR, because it just duplicates the source's configurations. Moreover, if you are not sure at all -\e[0m \e[31mPRESS 'e'!\e[0m\e[33m"
read ds
echo -e "\e[0m"
case $ds in
[s])
echo -e "\nSynchronizing..."
echo "Your prepared dom-file: "
cat $(dirname $0)/enhostdom/dom
read -p "OK?" ok
for l in `cat hosts | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; do
   scp $(dirname $0)/enhostdom/dom root@$l:/var/cache/bind/
   ssh root@$l invoke-rc.d bind9 reload
done;
ssl="$(dirname $0)/additional_ssl"
u="$(dirname $0)/unsynchronized.log"
#if test -f $u
#  then
    if test -f $ssl
      then
      echo -e "\e[31mWARNING! THERE ARE POSSIBLE UNFORESEEN CONSEQUENCES!!!\e[0m"
      $(dirname $0)/syncssl.sh
      echo -e "\e[1;97m"
      cat $ssl
      echo -e "\e[0m"
      else
if test -f $u
  then
$(dirname $0)/domfill.sh "$(dirname $0)/unsynchronized.log"
ansible-playbook add_domains.yml
  else 
    echo "You have not unsynchronized domains."
fi
fi
echo -ne '\e[36m#################################################################################              (85%)\e[0m\r'
break;;

[m]) echo -e "\e[31mWARNING! THERE ARE POSSIBLE UNFORESEEN CONSEQUENCES!!!\e[0m"
$(dirname $0)/syncssl.sh
break;;
[u]*)
u="$(dirname $0)/unsynchronized.log"
if test -f $u
then
echo -e "\nSynchronizing..."
$(dirname $0)/domfill.sh "$(dirname $0)/unsynchronized.log"
ansible-playbook add_domains.yml
else echo "You have not unsynchronized domains!"
fi
break;;

"dd") dd="$(dirname $0)/rooterr.log"
if test -f $dd
  then
  echo -e "\e[33mDELETING...\e[0m"
  $(dirname $0)/domfill.sh $dd
  ansible-playbook del_domains.yml
else echo -e "\e[33mHave not found these ones.\e[0m"
  fi
  break;;
"df") df="$(dirname $0)/rooterr0.log"
if test -f $df        
    then 
      cat $(dirname $0)/rooterr0.log | sort | uniq | tee $(dirname $0)/rooterr0
      echo -e "\e[33mDELETING...\e[0m"
        $(dirname $0)/domfill.sh "$(dirname $0)/rooterr0"
        ansible-playbook del_domains.yml
else echo -e "\e[0mHave not found these ones.\e[0m"
fi                        
break;;

"su") su="$(dirname $0)/diff.log"
if test -f $su
  then 
    echo -e "\e[33mLIST OF UNCHANGED DOMAINS: \e[0m\e[1;97m"
    cat $su | awk '{print$4}'
    echo -e "\e[0m"
else echo -e "\e[1;33mNothing to show!\e[0m"
  fi
  break;;

[d]*) ansible-playbook del_domains.yml
echo -ne '\e[36m########################################################################################       (85%)\e[0m\r'
break;;
"")break;;
"e"|"+") echo -ne '\e[36m#############################################################################################  (100%)\e[0m\r'
exit;;
*) echo "Make your choice!"
esac;
done

$(dirname $0)/ipsetcheck.sh $1 $2
