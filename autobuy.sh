ssh monitor tail -n1 iMacros/Downloads/alwaysrun.log | grep -wo http://.* | tee $(dirname $0)/a > /dev/null 2>1
awk -F "," '{print$1}' $(dirname $0)/a | tee $(dirname $0)/trash/b > /dev/null 2>1 
awk -F "/" '{print$3}' $(dirname $0)/b | tee $(dirname $0)/trash/autolog > /dev/null 2>1

for i in `cat $(dirname $0)/autolog`; do 
ping -c3 $i > /dev/null 2>&1
done

$(dirname $0)/checkdomain.sh
echo Sleeping 30sec...
sleep 30
$(dirname $0)/autobuy.sh
