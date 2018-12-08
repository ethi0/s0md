# GATHERING INFORMATION
SERIAL=`date +%F | awk -F "-" '{print$1$2$3"02"}'`
echo '$TTL' 1h > $(dirname $0)/dom
echo "@ IN SOA ns1 root (" >> $(dirname $0)/dom
echo "$SERIAL ; serial" >> $(dirname $0)/dom
echo "1h         ; refresh (1 hour)" >> $(dirname $0)/dom
echo "15m        ; retry (15 minutes)" >> $(dirname $0)/dom
echo "2w         ; expire (2 weeks)" >> $(dirname $0)/dom
echo "20m        ; minimum (20 minutes)" >> $(dirname $0)/dom
echo ")" >> $(dirname $0)/dom
ns=1


for i in `cat $(dirname $0)/enhostdom/domsw | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; 
do 
  echo "@ IN NS ns"$ns >> $(dirname $0)/dom;
((ns+=1))
done;
ns=1
for i in `cat $(dirname $0)/enhostdom/domsw | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`;
do 
  echo "ns$ns IN A $i" >> $(dirname $0)/dom;
((ns+=1))
done;

echo -e "\n\e[33mENTER A-NOTE:\e[0m "
read anote
anotec=`echo $anote | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
echo "@ IN A $anotec" >> $(dirname $0)/dom
echo "* IN A $anotec" >> $(dirname $0)/dom
#  PROCESS ABUSED IP-address
echo -e "\n\e[33mWrite an abused IP:\e[0m "
read abuse
abused=`echo $abuse | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"` 
#  SHOW PREPARED DOM
echo -e "\n\e[33mPREPARED FILE IS:\e[0m"
echo -e "******************************FILE************************************"
echo -e "\e[37m" 
cat $(dirname $0)/dom
echo -e "\e[0m"
echo -e "******************************FILE************************************"
#  WRITE DOM AND START/STOP SERVICES


while true; 
 do
   echo -e "\e[33m"
  read -p "WRITE TO SERVERS [y/n]?    " yn
  echo -e "\e[0m"
  case $yn in
  [y]|"")
  for i in `cat hosts | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`;
  do
       scp $(dirname $0)/dom root@$i:/var/cache/bind/
         ssh root@$i invoke-rc.d bind9 stop
        done;
         ssh root@$anotec invoke-rc.d bind9 restart;
         ssh root@$anotec invoke-rc.d nginx reload;
 ssh root@$i invoke-rc.d bind9 start;
         ssh root@$i invoke-rc.d nginx reload;
        if [[ "$abused" != "" ]];              
        then 
         ssh root@$abused invoke-rc.d bind9 stop
#        ssh root@$abused invoke-rc.d nginx stop
        else
          break;
          fi
        break;;
  [n]|"+") break;;
      * ) echo -e "\e[33mPlease answer yes or no.\e[0m";;
  esac
done
f=`cat hosts | wc -l`
m=1
echo -e "\e[33mUpdating...\e[0m"
for i in `cat hosts | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; do
rm $(dirname $0)/dom."$m"
 ssh root@$i sed '1,8d' /var/cache/bind/dom | tee $(dirname $0)/dom."$m" > /dev/null 2>&1
((m+=1))
done

