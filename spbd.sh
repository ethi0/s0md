#set -x
> $(dirname $0)/spbd
export ANSIBLE_INVENTORY=/home/fl/production
num=`grep -nr '\['$1'\]' /home/fl/production | awk -F ":" '{print$1}'`
let n=num+1
str=`cat /home/fl/production | head -n$n | tail -n1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
while [[ "$str" != "" ]] ; do
  echo $str >> $(dirname $0)/spbd
  ((n+=1))
  str=`cat /home/fl/production | head -n$n | tail -n1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
done

#cat $(dirname $0)/spbd
