while true;do
  read -p "Enter IP: " ip0
  ip=`echo $ip0 | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
  ssh root@$ip invoke-rc.d bind9 restart
  ssh root@$ip invoke-rc.d nginx restart
  echo -e "\e[33mChecking bind 53...\e[0m"
  timeout 5 telnet $ip 53 | grep Connected
  ssh root@$ip invoke-rc.d bind9 stop
  echo -e "\e[33mChecking nginx 80...\e[0m"
  timeout 5 telnet $ip 80 | grep Connected
done
