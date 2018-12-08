#!/bin/bash
#set -x
if [ -f "$1" ]
  then
echo -e "\e[1;96m[`date | awk '{print$4}'`]\e[0m \e[33m$2\e[0m"
> $(dirname $0)/compare.list
> $(dirname $0)/diff.log
> $(dirname $0)/diff2.log
> $(dirname $0)/normal0.list
> $(dirname $0)/normal.list
> $(dirname $0)/compare0.list
cat $1 |awk -F "," '{print$1}' | sort | uniq | tee -a $(dirname $0)/normal0.list > /dev/null 2>&1
awk '/./' $(dirname $0)/normal0.list | tee -a $(dirname $0)/normal.list > /dev/null 2>&1
cat $(dirname $0)/normal.list | xargs -n1 --max-procs=8 $(dirname $0)/rootnscheck.sh 

else echo "Skipped inspecting $1".
fi
