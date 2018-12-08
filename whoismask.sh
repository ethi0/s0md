read -p "Enter mask NS: " ns
read -p "Enter mask IP: " ip0
$(dirname $0)/domfill.sh $1
ip=$(echo $ip0 | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
list=`cat $(dirname $0)/d.list | wc -l`

check () {  
> $(dirname $0)/res_whois
cat $(dirname $0)/d.list | xargs -n1 --max-procs=20 whois {} | grep ns$1 | grep -v $2 | awk -F "." '{print$2"."$3}' >> $(dirname $0)/res_whois
count=$(grep -cve '^\s*$' $(dirname $0)/res_whois)
cat $(dirname $0)/res_whois | sort
echo -e "\e[33mTotal:\e[0m [\e[1;97m$list\e[0m]"
echo -e "\e[33mLeft:\e[0m  [\e[31m$count\e[0m]"
}

check $ns $ip

while true; do
  read -p "Recheck?" yn
  case $yn in
    ""|"y") check $ns $ip;;
    "+"|"n") break;;
    *) echo -e "\e[31mMake your choice!\e[0m";;
  esac
done
