> $(dirname $0)/additional_dom
for i in `cat hosts | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; do
note=`ssh root@$i ls /var/cache/bind/ | egrep -v '(managed-keys.bind|managed-keys.bind.jnl|master.conf)'`
note0=`ssh root@$i ls /etc/nginx/sites-enabled | egrep -v "default"`
if [ "$note" != "" ] && [ "$note" != "dom" ]
  then
echo -e "\e[33mAdditional files detected at \e[36m[$i]\e[0m\n\e[1;97m$note\e[0m\n\e[33mBe careful while switching or synchronizing settings.\e[0m"
echo $note > $(dirname $0)/additional_dom
fi
if [[ "$note0" != "" ]]
  then
  echo -e "\e[33mAlso, there are configuration files of SSL-domains at \e[36m[$i]\e[0m:\n\e[0m\n\e[1;97m$note0 \e[0m"
  echo $note0 | sed -e 's/ /\n/g' | awk -F "." '{print$1"."$2}' > $(dirname $0)/additional_ssl
fi
done
anote=`cat $(dirname $0)/anote`
addom=`cat $(dirname $0)/additional_dom`
if [[ "$addom" == "" && "$note0" == "" ]]
then
echo -e "[\e[1;96m`date | awk '{print$4}'`\e[0m] \e[32mNo additional files found.\e[0m" | tee -a $(dirname $0)/report.log
fi
