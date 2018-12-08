#set -x
> $(dirname $0)/domain0
m=1
for i in `cat hosts | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; do
if [[ "$1" == "1" ]]
then 
 ssh root@$i cat /var/cache/bind/master.conf | awk '{print$2","$7}' | awk -F '"' '{print$1$2"_"$4"_"}' | tee -a $(dirname $0)/master.conf."$m" | awk -F "_" '{print$1}' | tee -a $(dirname $0)/domain0 > /dev/null 2>&1
mas=$(dirname $0)/master.conf."$m"

if [ ! -s "$mas" ]
  then 
  echo -e "\e[33mCreating empty\e[0m \e[1;96mmaster.conf\e[0m \e[33mon\e[0m \e[1;97mNS$m\e[0m [\e[1;97m$i\e[0m]..." | tee -a $(dirname $0)/report.log
   ssh root@$i touch /var/cache/bind/master.conf
fi


 ssh root@$i cat /etc/nginx/nginx.conf | grep -v "#server_name .com .net .biz .info .in .com.ua .rv.ua .org.ua .in.ua .ca .at .eu .org .pl .pl.ua .us .pro .nl .co.cc .ru .su .sea .pw .de .uk .xn--p1ai .be .se .center .support .uno .club;"| grep -v "server_name lock" |grep -E "server_name ."| grep -Eo "([a-z0-9\w-]{1,200})\.([a-z]{1,6})" | tee -a $(dirname $0)/domain0 | tee $(dirname $0)/nginx.conf."$m" > /dev/null 2>&1
ng=$(dirname $0)/nginx.conf."$m"
if [ ! -s "$ng" ]                      
        then echo -e "\e[31mnginx.conf\e[0m \e[33mis absent or without domains at\e[0m \e[1;97mNS$m\e[0m [\e[1;97m$i\e[0m]!" | tee -a $(dirname $0)/report.log
fi


 ssh root@$i sed '1,8d' /var/cache/bind/dom | tee $(dirname $0)/dom."$m" > /dev/null 2>&1
dom=$(dirname $0)/dom."$m"
if [ ! -s "$dom" ]
    then echo -e "\e[33mCreating dummy\e[0m \e[1;96mdom\e[0m \e[33mon\e[0m \e[1;97mNS$m\e[0m [\e[1;97m$i\e[0m]..." | tee -a $(dirname $0)/report.log
     ssh root@$i touch /var/cache/bind/dom
fi

elif [[ "$1" == "0" ]]
then
 ssh root@$i cat /etc/nginx/nginx.conf | grep -v "#server_name .com .net .biz .info .in .com.ua .rv.ua .org.ua .in.ua .ca .at .eu .org .pl .pl.ua .us .pro .nl .co.cc .ru .su .sea .pw .de .uk .xn--p1ai .be .se .center .support .uno .club;"| grep -v "server_name lock .microsoft.com .ltinetworks.com;" |grep -E "server_name ."| grep -Eo "([a-z0-9\w-]{1,200})\.([a-z]{1,6})" | tee -a $(dirname $0)/domain0 | tee $(dirname $0)/nginx.conf."$m" > /dev/null 2>&1
fi

ng=$(dirname $0)/nginx.conf."$m"
if [ ! -s "$ng" ]                          
          then echo -e "\e[31mnginx.conf\e[0m \e[33mis absent or without domains at\e[0m \e[1;97mNS$m\e[0m [\e[1;97m$i\e[0m]!" | tee -a $(dirname $0)/report.log
          fi

((m+=1))


done
cat $(dirname $0)/domain0 | sort | uniq > $(dirname $0)/domain
