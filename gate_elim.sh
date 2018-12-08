#set -x
$(dirname $0)/enhosts.sh "elim"
> $(dirname $0)/domain0
> $(dirname $0)/domain_elim
for i in `cat hosts | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; do
   ssh root@$i cat /var/cache/bind/master.conf | grep -Eo "([a-z0-9\w-]{1,200})\.([a-z]{1,6})" | tee -a $(dirname $0)/domain0 > /dev/null 2>&1
   ssh root@$i cat /etc/nginx/nginx.conf | grep -v "#server_name .com .net .biz .info .in .com.ua .rv.ua .  org.ua .in.ua .ca .at .eu .org .pl .pl.ua .us .pro .nl .co.cc .ru .su .sea .pw .de .uk .xn--p1ai .be .   se .center .support .uno .club;"| grep -v "server_name lock .microsoft.com .ltinetworks.com;" |grep -E   "server_name ."| grep -Eo "([a-z0-9\w-]{1,200})\.([a-z]{1,6})" | tee -a $(dirname $0)/domain0 > /dev/null 2>&1
done
cat $(dirname $0)/domain0 | sort | uniq > $(dirname $0)/domain_elim
qd=`cat $(dirname $0)/domain_elim | wc -l`
$(dirname $0)/domfill.sh "$(dirname $0)/domain_elim"
echo -e "\e[33mPrepared list to DELETE:"
cat $(dirname $0)/domain_elim
while true; do
echo -e "\e[31m"
read -p "Ready do delete [$qd] domains? [y|n] ?  " yn
echo -e "\e[0m"
case $yn in
[y]|"") ansible-playbook del_domains.yml
for i in `cat hosts | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; do
   ssh root@$i invoke-rc.d bind9 stop
   ssh root@$i invoke-rc.d nginx reload
done;
break;;
"n"|"+") exit;;
*) echo Make your choice!
esac
done
