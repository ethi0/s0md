echo Flushing chains...
for i in `cat hosts | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`; do
   ssh root@$i iptables -t nat -F PREROUTING
   ssh root@$i ipset destroy
done
echo -ne '\e[36m#############################################################################################  (100%)\e[0m\r'
echo -e "\n"
