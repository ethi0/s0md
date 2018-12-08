#set -x
anote=`cat $(dirname $0)/anote`

echo -e "\e[33mTHE SOURCE IS\e[0m [\e[1;97m$anote\e[0m]"
while true; do
  read -p "Do you want to change the SOURCE?" sc
  case $sc in
  "y"|"") anote0=""
  while [ "$anote0" == "" ] ; do
    echo -en "\e[33mEnter IP: \e[0m"
    read ip0
    anote0=`echo $ip0 | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
    if [[ "$anote0" != "" ]]
      then anote=$anote0
      else echo FALSE > /dev/null 2>&1
    fi
    done
    break;;
  "n"|"+") break;;
  *) echo -e "\e[31mMAKE YOUR CHOICE!\e[0m"
  esac;
done
echo -e "\e[33mPLEASE WAIT...\e[0m"
scp -r root@$anote:/etc/nginx/certs ~/$(dirname $0)/anotef/  > /dev/null 2>&1
scp -r root@$anote:/etc/nginx/sites-enabled ~/$(dirname $0)/anotef/  > /dev/null 2>&1
scp -r root@$anote:/etc/nginx/ssl ~/$(dirname $0)/anotef/  > /dev/null 2>&1
scp -r root@$anote:/floppy/home/acme/.acme.sh/ ~/$(dirname $0)/anotef > /dev/null 2>&1
scp -r root@$anote:/var/cache/bind/ ~/$(dirname $0)/anotef/ > /dev/null 2>&1 
scp -r root@$anote:/etc/letsencrypt/ ~/$(dirname $0)/anotef/ > /dev/null 2>&1
scp root@$anote:/etc/nginx/acme ~/$(dirname $0)/anotef/ > /dev/null 2>&1
scp root@$anote:/etc/nginx/nginx.conf ~/$(dirname $0)/anotef/ > /dev/null 2>&1
echo -e "\e[1;97mCERTS\e[0m\e[33m are copied...\e[0m"
cat hosts | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}" |grep -v $anote | tee $(dirname $0)/hostssl  > /dev/null 2>&1
sleep 3
echo -e "\e[33mYou will sync the gates:\e[0m"
cat $(dirname $0)/hostssl
echo -e "\e[1;97mnginx.conf\e[0m \e[33mis prepared...\e[0m"
$(dirname $0)/nx_norm.sh "$(dirname $0)/anotef/nginx.conf"
while true;do 
echo -e "\e[31m"
read -p "READY? " $yn
echo -ne "\e[0m"
case $yn in
"y"|"")
for i in `cat $(dirname $0)/hostssl`; do
  echo -e "[\e[1;97m$i\e[0m] \e[33mis being synchronized...\e[0m"
  scp -r /home/fl/$(dirname $0)/anotef/certs/ root@$i:/etc/nginx/ > /dev/null 2>&1
  echo -e "\e[1;97mCerts\e[0m \e[33mcopied...\e[0m"
  scp -r /home/fl/$(dirname $0)/anotef/sites-enabled/ root@$i:/etc/nginx/  > /dev/null 2>&1
  echo -e "\e[1;97mSites-enabled\e[0m\e[33m copied...\e[0m"
  scp -r /home/fl/$(dirname $0)/anotef/ssl/ root@$i:/etc/nginx/  > /dev/null 2>&1
  echo -e "\e[1;97mSSL \e[0m\e[33mcopied...\e[0m"
  ssh root@$i mkdir -p /floppy/home/ > /dev/null 2>&1
  scp -r /home/fl/$(dirname $0)/anotef/.acme.sh/ root@$i:/floppy/home/  > /dev/null 2>&1
  for ssl in `cat $(dirname $0)/additional_ssl`; do ssh root@$i ln -sf /floppy/home/acme/.acme.sh/$ssl/ /etc/nginx/certs/ > /dev/null 2>&1; done
  scp /home/fl/$(dirname $0)/anotef/acme root@$i:/etc/nginx/ > /dev/null 2>&1
  echo -e "\e[1;97mAcme\e[0m \e[33mcopied. Links created...\e[0m"
  scp -r /home/fl/$(dirname $0)/anotef/letsencrypt/ root@$i:/etc/ > /dev/null 2>&1
  echo -e "\e[1;97m/etc/letsencrypt/\e[0m \e[33mcopied...\e[0m"
  scp /home/fl/$(dirname $0)/anotef/nginx.conf root@$i:/etc/nginx/ > /dev/null 2>&1
  echo -e "\e[1;97mnginx.conf\e[0m \e[33mcopied...\e[0m"
  scp -r /home/fl/$(dirname $0)/anotef/bind/ root@$i:/var/cache/ > /dev/null 2>&1
  echo -e "\e[1;97mBind\e[0m \e[33mcopied...\e[0m"
   ssh root@$i invoke-rc.d bind9 reload > /dev/null 2>&1 
   ssh root@$i nginx -t
   ssh root@$i invoke-rc.d nginx reload 
done
break;;
"+"|"") echo -e "\e[33mSKIPPED.\e[0m"
break;;
*) echo -e "\e[31mMAKE YOUR CHOICE!\e[0m"
esac
done
