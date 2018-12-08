cat hosts | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | xargs -n1 --max-procs=4 $(dirname $0)/back.sh
