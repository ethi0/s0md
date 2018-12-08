a=`cat $(dirname $0)/autobuygroup`
echo "Gate offline $a:" > $(dirname $0)/mail
cat $(dirname $0)/abused | tee -a somd/mail
echo "Switched to: " >> $(dirname $0)/mail
cat $(dirname $0)/anote | tee -a somd/mail
echo "Taking control.." >> $(dirname $0)/mail
