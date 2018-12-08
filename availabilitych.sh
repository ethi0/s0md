#!/bin/bash
#set -x
> $(dirname $0)/suspected.log
> $(dirname $0)/rooterr0.log
ch0=`cat hosts | wc -l`
let ch=ch0-1
echo

cat $(dirname $0)/domain | xargs -n1 --max-procs=20 $(dirname $0)/xargavailch.sh 0 $ch

r=`cat $(dirname $0)/suspected.log`
if [ "$r" == "" ]
  then
  echo -e "[\e[1;96m`date | awk '{print$4}'`\e[0m] \e[32mAll DOMAINS are OK.\e[0m" | tee -a $(dirname $0)/report.log
rm $(dirname $0)/suspected.log
fi
