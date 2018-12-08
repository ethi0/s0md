#echo -e "\nContinue only if you are sure, that your domains are in $(dirname $0)/d.list."                
$(dirname $0)/domfill.sh
ansible-playbook del_domains.yml
