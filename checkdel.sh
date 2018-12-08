$(dirname $0)/cleaner.sh
$(dirname $0)/domfill.sh $i





checkr () {
for i in `cat $(dirname $0)/d.list`; do
          m=`whois $i | grep "DELEGATED"`
          w=`whois $i | grep ns1`
          echo $i $m | grep -v "NOT DELEGATED" | awk '{print$1}'
          echo $w
done
}

checkr
while true; do
    read -p "Recheck?" yn
      case $yn in
          "y"|"") checkr;;
          "n"|"+") break;;
                *) echo -e "\e[31mMake your choice!\e[0m";;
      esac
done
