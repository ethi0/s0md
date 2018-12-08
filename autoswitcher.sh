echo > $(dirname $0)/abused

#DETECT THE ABUSED HOST

j=2
for i in `cat $(dirname $0)/hosts | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`;
do 
  p=`ping -c1 $i | grep -Eo "1 received"`;
  if [[ $p == "1 received" ]]
    then
       echo -e "\e[96m$i\e[0m is \e[32monline\e[0m."
      ((j+=1))
      else
      echo -e "\e[96m$i\e[0m is \e[31moffline\e[0m."                                                
      sed -i "${j}d" $(dirname $0)/hosts
      let "f=j-1"
      echo $i NS$f >> $(dirname $0)/abused
      fi
done;


scp $(dirname $0)/abused control:/home/user
scp $(dirname $0)/autobuygroup control:/home/user
scp $(dirname $0)/hosts control:/home/fl/user
scp $(dirname $0)/hosts0 control:/home/fl/user
ssh control /home/user/$(dirname $0)/prexecutor_server.sh
ssh control /home/user/$(dirname $0)/switcher_server.sh
