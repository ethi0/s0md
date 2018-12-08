$(dirname $0)/enhosts_new_gate.sh
case "$1" in
[1]) ansible-playbook new_gate_ipset.yml
break;;
[0]) ansible-playbook named.yml
break;;
*) exit 1
esac
