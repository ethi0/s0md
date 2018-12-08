while true; do
  echo -e "\e[33m"Do you want to: 
  echo -e "Add [u]nsynchronized domains / "
  echo -e "Delete [d]omains / "
  echo -e "DELETE locked/unactivated domains[dd] / "
  echo -e "DELETE OTHER GRs' domains [df] / "
  echo -e "Mirror gates[m] / "
  echo -e "Continue checking (Enter), [e]xit?  " 
  read sdc
  echo -e "\e[0m"
  case $sdc in
u) ssl="$(dirname $0)/additional_ssl"
if test -f $ssl
then echo -e "\e[31mWARNING: EXPERIMENTAL FUNCTION!\e[0m"
$(dirname $0)/syncssl.sh
      echo -e "\e[1;97m"
      cat $ssl
      echo -e "\e[0m"
      else 
$(dirname $0)/domfill.sh "$(dirname $0)/unsynchronized.log"
ansible-playbook add_domains_wdns.yml;
fi
echo -ne '\e[36m#######################################################################                        (75%)\e[0m\r'
$(dirname $0)/ipsetcheck.sh $1 $2
break;;
d) $(dirname $0)/domfill.sh "$(dirname $0)/err.log";
ansible-playbook del_domains.yml
echo -ne '\e[36m#######################################################################                        (75%)\e[0m\r'
$(dirname $0)/ipsetcheck.sh $1 $2
break;;

m) echo -e "\e[31mWARNING: EXPERIMENTAL FUNCTION!\e[0m"
$(dirname $0)/syncssl.sh
$(dirname $0)/ipsetcheck.sh $1 $2
break;;

"dd") dd="$(dirname $0)/rooterr.log"
if test -f $dd
    then 
    echo -e "\e[33mDELETING...\e[0m"
    $(dirname $0)/domfill.sh "$(dirname $0)/rooterr.log"
    ansible-playbook del_domains.yml
    else echo -e "\e[33mHave not found these ones.\e[0m"
      fi
      break;;
"df") df="$(dirname $0)/rooterr0.log"
if test -f $df        
    then                      
      cat $(dirname $0)/rooterr0.log | sort | uniq | tee rooterr0
      echo -e "\e[33mDELETING...\e[0m"
      $(dirname $0)/domfill.sh "$(dirname $0)/rooterr0"
      ansible-playbook del_domains.yml
else echo -e "\e[0mHave not found these ones.\e[0m"
fi                        
    break;;

"") break;;
"e"|"+") echo -ne '\e[36m#################################################################################              (100%)\e[0m\r'
exit;;
*) echo Make your choice!
esac;
done;
$(dirname $0)/ipsetcheck.sh $1 $2
