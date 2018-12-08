while true; do
  read -p "Enter IP: " ip0
  ip=`echo $ip0 | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
  ssh-copy-id root@$ip
done
