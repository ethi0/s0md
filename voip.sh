#set -x
while true; do
  read -p "Number of voip: " vp
  
  read -p "IP1: " ip1
  echo -e "\e[33mPass IP1: \e[0m"
  scp ~/voip_vpn/voip"$vp".tar.xz root@$ip1:/errata/etc/openvpn

  read -p "IP2: " ip2
  echo -e "\e[33mPass IP2: \e[0m"
  scp ~/voip_vpn/voip"$vp".tar.xz root@$ip2:/errata/etc/openvpn

done
