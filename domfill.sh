#set -x
echo "---" > domains.yml
echo "domains:" >> domains.yml
if [ "$1" ]
then
cat $1 | sort | uniq  > $(dirname $0)/domain
sed '/^$/d' $(dirname $0)/domain > $(dirname $0)/d.list
for i in `cat $(dirname $0)/d.list`; do
  echo "  - $i" >> domains.yml
done;
else

> $(dirname $0)/d.list
echo --- > domains.yml
echo domains: >> domains.yml
echo > $(dirname $0)/domain0
echo -e "\e[33mEnter the list of domains here!\e[0m"
read domain0
while [ "$domain0" != "" ]
    do
    echo $domain0 | grep -Eo "([a-z0-9\w-]{1,200})\.([a-z]{1,6})" >> $(dirname $0)/domain0
    read domain0 >> $(dirname $0)/domain0
done;
sed '/^$/d' $(dirname $0)/domain0 > $(dirname $0)/d.list
for i in `cat $(dirname $0)/d.list | grep -Eo "([a-z0-9\w-]{1,200})\.([a-z]{1,6})"`; do  
  echo "  - $i" >> domains.yml
done 
fi
