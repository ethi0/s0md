d=`dig $1 +short`
echo -e "\e[33mInstant information: A-note is\e[0m [\e[1;96m$d\e[0m]"

dig @f.dns.ripn.net $1 | grep ns | awk -F "NS" '{print$2}' | tee test > /dev/null 2>&1
b=`cat test`
if [[ "$b" == "" ]]
then echo ERROR.
exit;
fi

c=`tail -n1 test | awk -F "." '{print$2"."$3}'`
if [[ "$c" != "$1" ]]
	then
	echo Domain $1 uses A-Note of registrar $c !
fi
