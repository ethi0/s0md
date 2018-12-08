#set -x
d=`cat $(dirname $0)/autolog`

ssh monitor cat iMacros/Datasources/checkdomain.csv | tee $(dirname $0)/file > /dev/null 2>1
awk /"$d"/ $(dirname $0)/file | tee $(dirname $0)/file2 > /dev/null 2>1
c=`awk -F ", " '{print$2}' $(dirname $0)/file2` > /dev/null 2>1
#echo c=$c
cat $(dirname $0)/file2 | grep -E ", $c," | tee $(dirname $0)/file3 > /dev/null 2>1
f=`awk -F ", " '{print$2}' $(dirname $0)/file3` 
echo $f 
g=`awk /,$f,/ $(dirname $0)/fgroup.list` > /dev/null 2>1
echo $g > $(dirname $0)/file4
h=`awk -F "," '{print$6}' $(dirname $0)/file4` 
echo $h > $(dirname $0)/autobuygroup
$(dirname $0)/detector.sh
