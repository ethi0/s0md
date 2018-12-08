#set -x
err=""
for i in `cat $(dirname $0)/inspect0.list`; do
  f=`echo $i | awk -F "_" '{print$2}'`
  ns=`cat $(dirname $0)/spbd | grep $f`
  if [[ "$ns" == "" ]]
    then 
    echo -e "\e[1;96mGate [\e[0m\e[1;97m$i\e[0m\e[1;96m] is\e[0m \e[31mDOWN or INCORRECT\e[0m \e[1;96mby\e[0m \e[1;97mSP-info. Also, it may have an additional IP-address.\e[0m"
    err="err"
  fi
done

if [[ "$err" == "" ]]
  then 
  echo -e "\e[32mJIRA-info is similar to SP.\e[0m"
fi
