#!/bin/bash
$(dirname $0)/cleaner.sh
$(dirname $0)/domfill.sh $1


ssl_check() {
  for i in $(cat $(dirname $0)/d.list); do
	echo -e "\e[1;95m$i\e[0m         \e[33m [$(dig $i +short)]\e[0m"
	curl "https://$i"
  done
}



ssl_check
while true; do
  read -p "Recheck?" yn
  case $yn in
    "y"|"") ssl_check;;
    "n"|"+") break;;
    *) echo -e "\e[31mMake your choice!\e[0m";;
  esac
done
