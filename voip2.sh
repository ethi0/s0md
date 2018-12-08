while true; do
  read -p "Enter IP: " ip
  ssh root@$ip
done
