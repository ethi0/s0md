pass=`openssl rand -base64 18`
echo -e "\e[1;96mPassword is:\e[0m \e[33m$pass\e[0m"
hash=`openssl passwd -1 -noverify $pass`
echo -e "\e[1;96mHash is:\e[0m \e[33m$hash\e[0m"
cont_pass=`openssl rand -base64 48`
echo -e "\e[1;96mCont_pass is:\e[0m \e[33m$cont_pass\e[0m"
domain=`cat $(dirname $0)/randomlist | shuf -n1`
echo -e "\e[33m"

read -p "Enter hostsNum or leave empty for default: " hn
if [[ "$hn" != "" ]]
  then
    $(dirname $0)/enhosts.sh "elim" $hn "nodom"
  else
    $(dirname $0)/enhosts.sh "elim"
fi
echo -e "\e[0m"
ansible-playbook setup.yml -i hosts$hn

echo -e "\e[33mIf you forgot:\e[0m"
echo -e "\e[1;96mPassword is:\e[0m \e[33m$pass\e[0m"
echo -e "\e[1;96mCont_pass is:\e[0m \e[33m$cont_pass\e[0m"
rm hosts$hn
