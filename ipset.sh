if [[ "$2" == "1" && $3 != "inst" ]]
  then
    $(dirname $0)/enhosts.sh "ipset"
    elif [[ "$2" == "1" && $3 == "inst" ]]
    then
    echo OK > /dev/null 2>&1
elif [[ "$2" != "1" ]]
    then
      echo NON-IPset group!
      exit;
fi


> $(dirname $0)/domain0
> $(dirname $0)/domain_add
for i in `cat hosts | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; do
 ssh root@$i cat /var/cache/bind/master.conf | grep -Eo "([a-z0-9\w-]{1,200})\.([a-z]{1,6})" | tee -a $(dirname $0)/domain0 > /dev/null 2>&1
 ssh root@$i cat /etc/nginx/nginx.conf | grep -v "#server_name .com .net .biz .info .in .com.ua .rv.ua .  org.ua .in.ua .ca .at .eu .      org .pl .pl.ua .us .pro .nl .co.cc .ru .su .sea .pw .de .uk .xn--p1ai .be .   se .center .support .uno .club;"| grep -v "server_name lock .microsoft.com .ltinetworks.com;" |grep -E "server_name ."| grep -Eo "([a-z0-9\w-]{1,200})\.([a-z]{1,6})" | tee -a $(dirname $0)/domain0 > /dev/null 2>&1
done

while true; do
read -p "Do you have SSL-domains on the group? [y/n]" yn
case $yn in
[y]|"") ansible-playbook ipset_new.yml
break;;
[n]|"+") 
cp $(dirname $0)/ipset_new.yml /home/fl/ipset2.yml
ansible-playbook ipset2.yml
cat $(dirname $0)/domain0 | sort | uniq > $(dirname $0)/domain_add
echo Cleaning...
rm ipset2.yml       
       $(dirname $0)/domfill.sh "$(dirname $0)/domain_add"
       echo -e "\e[33mPrepared list to ADD:"
       cat $(dirname $0)/domain_add
       while true; do
         echo -e "\e[31m"
         read -p "Ready? [y|n] ?  " yn
         echo -e "\e[0m"
         case $yn in
         [y]|"") if [[ "$1" == "1" ]]
         then
         ansible-playbook add_domains.yml
         elif [[ "$1" == "0" ]]
         then 
         ansible-playbook add_domains_wdns.yml
         fi
         break;;
          [n]|"+") exit;;
          *) echo Make your choice!
         break;;
         esac
       done
break;;
*) echo Make your choice!
break;;
esac
done

if [[ "$2" != "1" ]]
  then
  echo NON-IPset group!
fi
