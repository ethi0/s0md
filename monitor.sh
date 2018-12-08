echo > $(dirname $0)/autochecklist0
echo > $(dirname $0)/autochecklist1
echo > $(dirname $0)/autochecklist
scp monitor:~/iMacros/Datasources/checkdomain.csv $(dirname $0)/
sed '1d' $(dirname $0)/checkdomain.csv > $(dirname $0)/autochecklist0
cat $(dirname $0)/autochecklist0 | awk -F ", " '{print$2","$3}' | tee $(dirname $0)/autochecklist1 > /dev/null 2>&1;
sed 'N;$!P;$!D;$d' $(dirname $0)/autochecklist1 > $(dirname $0)/autochecklist 
for i in `cat $(dirname $0)/autochecklist`; do
echo $i | awk -F "," '{print$1}' > $(dirname $0)/autobuygroup
echo $i | awk -F "," '{print$2}' > $(dirname $0)/autolog
$(dirname $0)/detector.sh
echo > $(dirname $0)/autobuygroup
echo > $(dirname $0)/autolog
done;
echo Sleeping 30 sec...
$(dirname $0)/cleaner.sh
sleep 30
$(dirname $0)/monitor.sh
