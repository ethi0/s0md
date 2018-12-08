read -p "Enter target host: " i
read -p "Enter ssl-domain: " domain 

ansible-playbook tls.yml 

ssh root@$i invoke-rc.d bind9 start
c='zone "'$domain'" { type master; file "'$domain'" }'
echo $c
#exit;
ssh root@$i 'echo $c | tee -a /var/cache/bind/master.conf'
ssh root@$i cp /var/cache/bind/dom /var/cache/bind/'$domain'
ssh root@$i /floppy/home/acme/bin/acme.sh --issue --dns -d $domain -d www.$domain |grep "TXT value" | awk -F "'" '{print$2}' | tee trash/keys
a=`cat trash/keys | head -n1 | tail -n1`
b=`cat trash/keys | head -n2 | tail -n1`
d="_acme-challenge IN TXT $a"
e="_acme-challenge.www IN TXT $b"
echo $d
echo $e
ssh root@$i 'echo '$d' |tee -a /var/cache/bind/'$domain''
ssh root@$i 'echo '$e' |tee -a /var/cache/bind/'$domain''
ssh root@$i rndc reload
ssh root@$i /floppy/home/acme/bin/acme.sh --renew -d $domain -d www.$domain
ssh root@$i ln -sf /floppy/home/acme/.acme.sh/'$domain'/ /etc/nginx/certs/
echo Prepare nginx yourself!
echo "Copy this to /etc/nginx/nginx.conf:"
echo -e "\nserver {"
echo "         listen 80;"
echo "         server_name *.$domain;"
echo "         server_name $domain;"
echo "                 return 302 https://$domain$"request_uri";"
echo "}"

echo -e "\nUncomment include /etc/nginx/sites-enabled/*.conf;"
