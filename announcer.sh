if [ "$3" == "1" ]
then
	m="uses DNS"
	elif [[ "$3" == "0" ]]
	then
	m="uses A-Notes of registrar"
fi

if [[ "$4" == "1" ]]
  then 
  i="\e[32mPOSITIVE\e[0m"
  elif [[ "$4" == "0" ]]
  then 
  i="\e[31mNEGATIVE\e[0m"
fi
echo -e "You are working with [\e[1;96m$1\e[0m]". | tee -a $(dirname $0)/report.log
echo -e "The \e[33mquantity\e[0m of gates is [\e[1;96m$2\e[0m]". | tee -a $(dirname $0)/report.log
echo -e "This group \e[1;96m$m\e[0m". | tee -a $(dirname $0)/report.log
echo -e "IPSET-status is $i". | tee -a $(dirname $0)/report.log

