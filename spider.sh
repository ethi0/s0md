$(dirname $0)/cleaner.sh
echo "[gates]" > hosts
if [[ "$1" == "" ]]
  then
read -p "Give me IP or domain: " ipd
s=`echo $ipd | grep -Eo "([a-z0-9\w-]{1,200})\.([a-z]{1,6})"`
k=`echo $ipd | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`

if [[ "$s" != "" ]]
  then
  dig ax.$s +short | tee -a hosts
  $(dirname $0)/prexecutor.sh "SP"
elif [[ "$k" != "" ]]
  then
  echo $k >> hosts
  $(dirname $0)/prexecutor.sh "SP"
  else
    echo SORRY! Unrecognized data!
fi

else
  $(dirname $0)/sp_exip.sh
fi

$(dirname $0)/cleaner.sh
