#set -x

if [[ "$3" == "" ]]
  then
    echo "[gates]" > hosts
    echo "[gates]" > $(dirname $0)/enhostdom/domsw
    > $(dirname $0)/inspect0.list
    SERIAL=`date +%F | awk -F "-" '{print$1$2$3"01"}'`
echo '$TTL' 1h > $(dirname $0)/enhostdom/dom
echo "@ IN SOA ns1 root (" >> $(dirname $0)/enhostdom/dom
echo "$SERIAL ; serial" >> $(dirname $0)/enhostdom/dom
echo "1h         ; refresh (1 hour)" >> $(dirname $0)/enhostdom/dom
echo "15m        ; retry (15 minutes)" >> $(dirname $0)/enhostdom/dom
echo "2w         ; expire (2 weeks)" >> $(dirname $0)/enhostdom/dom
echo "20m        ; minimum (20 minutes)" >> $(dirname $0)/enhostdom/dom
echo ")" >> $(dirname $0)/enhostdom/dom
echo -e "\n\e[33mWORK WITH JIRA,\e[0m \e[31mNOT HMS!\e[0m"
echo -e "Put the \e[33mFULL list\e[0m of hosts only!"
for ((ns=1; ns<=$1; ns++)); do
echo "@ IN NS ns"$ns >> $(dirname $0)/enhostdom/dom
done;
fi

if [[ "$1" == "elim" || "$1" == "ipset" ]]
  then
    if [[ "$2" != "" && "$2" != "sp" ]]
      then
        echo "[gates]" > hosts$2
        ipc=0
        while [[ "$ipc" != "" ]]; do
          echo -ne "\e[33mEnter IP-address:\e[0m "
          read ip
          ipc=`echo $ip | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
          echo $ipc >> hosts$2
          done
    elif [[ "$2" == "" ]]
  then
    echo "[gates]" > hosts
    ipc=0
    while [[ "$ipc" != "" ]]; do
      echo -ne "\e[33mEnter IP-address:\e[0m "
      read ip           
      ipc=`echo $ip | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
      echo $ipc >> hosts
    done;
    fi

elif [[ "$2" == "sp" ]]
  then
  ns=1            
  for i in `cat $(dirname $0)/sp_res.log`; do
    echo "ns$ns IN A $i" >> $(dirname $0)/enhostdom/dom
    echo "ns$ns""_"$i >> $(dirname $0)/inspect0.list
    echo $i >> hosts
    ((ns+=1))
  done


else
echo -ne '###\r'
ns=1
let limit=$1+1
h=`cat hosts | wc -l`
while [ $h -lt $limit ]
  do 
    echo -ne "\e[33mEnter IP-address:\e[0m "
    read ip 
    ipc=`echo $ip | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
    if [[ "$ipc" != "" ]]
      then 
      echo "ns$h IN A $ipc" >> $(dirname $0)/enhostdom/dom
      echo "ns$h""_"$ipc >> $(dirname $0)/inspect0.list
      echo $ipc >> hosts
      echo $ipc >> $(dirname $0)/enhostdom/domsw
      h=`cat hosts | wc -l`
    fi
done
fi
