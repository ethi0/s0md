# GATHERING INFORMATION
echo '$TTL' 1h > $(dirname $0)/dom
echo "@ IN SOA ns1 root (" >> $(dirname $0)/dom
echo "2017082401 ; serial" >> $(dirname $0)/dom
echo "1h         ; refresh (1 hour)" >> $(dirname $0)/dom
echo "15m        ; retry (15 minutes)" >> $(dirname $0)/dom
echo "2w         ; expire (2 weeks)" >> $(dirname $0)/dom
echo "20m        ; minimum (20 minutes)" >> $(dirname $0)/dom
echo ")" >> $(dirname $0)/dom
ns=1
for i in `cat $(dirname $0)/hosts0 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; 
do 
  echo "@ IN NS ns"$ns >> $(dirname $0)/dom;
((ns+=1))
done;
ns=1
for i in `cat $(dirname $0)/hosts0 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`;
do 
  echo "ns$ns IN A $i" >> $(dirname $0)/dom;
((ns+=1))
done;

anotec=`cat $(dirname $0)/anote | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
echo "@ IN A $anotec" >> $(dirname $0)/dom
echo "* IN A $anotec" >> $(dirname $0)/dom
#  SHOW PREPARED DOM
echo -e "\n\e[33mPREPARED FILE IS:\e[0m"
echo -e "******************************FILE************************************"
echo -e "\e[37m" 
cat $(dirname $0)/dom
echo -e "\e[0m"
echo -e "******************************FILE************************************"
#  WRITE DOM AND START/STOP SERVICES


for i in `cat $(dirname $0)/hosts | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`;
  do
      scp $(dirname $0)/dom root@$i:/var/cache/bind/
        ssh root@$i invoke-rc.d bind9 stop
        done;
        ssh root@$anotec invoke-rc.d bind9 start;
        ssh root@$anotec invoke-rc.d nginx reload;
ssh root@$i invoke-rc.d bind9 start;
        ssh root@$i invoke-rc.d nginx reload;
        if [[ "$abused" != "" ]];              
        then 
        ssh root@$abused invoke-rc.d bind9 stop
#        ssh root@$abused invoke-rc.d nginx stop
          fi
$(dirname $0)/cleaner.sh
$(dirname $0)/mail_composer.sh
cat $(dirname $0)/mail
