echo "[gates]" > hosts
echo > $(dirname $0)/h.list
echo -e "\e[33mEnter the list of hosts here!\e[0m"
read -p "Enter IP: " ip0
while [ "$ip0" != "" ]
    do 
    echo $ip0 | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}" >> $(dirname $0)/h.list
  read -p "Enter IP: " ip0
done;

for i in `cat $(dirname $0)/h.list | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; do  
    echo $i >> hosts
done 

   echo PREPARED LIST OF GATES TO INSTALL:
   cat hosts;
   exit 0;
