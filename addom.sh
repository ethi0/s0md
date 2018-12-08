$(dirname $0)/domfill.sh
case $1 in
[1]*) ansible-playbook add_domains.yml
break;;
[0]*) ansible-playbook add_domains_wdns.yml
break;;
*) echo Please, take a DECISION!
esac
