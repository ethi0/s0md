#!/bin/bash
$(dirname $0)/cleaner.sh
#set -x
user=$(whoami)
v=0.43.4.6
echo -e "*******************************************\e[1;31mWARNING!\e[0m"****************************************
echo
echo -e "\e[32mHello,\e[0m \e[1;96m$user\e[0m\e[32m!\e[0m"
echo -e "\e[1;31mBy accessing this program, you approve, that you do not have FAIL-domains at monitoring.\e[0m"
echo 
echo -e "\e[33mRead man before use (Press "h" to read)!\e[0m"
echo -e "\e[32mSoD: explainshell.com\e[0m"
echo -e "\e[32mNow with multithreading.\e[0m"
echo -e "\e[32mEnhanced domains' NSs recognition.\e[0m"
echo -e "\e[32mAdded RootNS-cache."
echo -e "\e[32mAdded SSL-check."
echo -e "\e[33mPLANNED: Update IPSET-handler."
echo -e "\e[33m******** BackRes-System."
echo -e "\e[33m******** IPtables interface."
echo -e "\e[31mZero chance.\e[0m"
#echo -e "\e[31mTough problem solution.\e[0m"
echo -e "\e[32mSOMD v.$v\e[0m\n"

while true; do
  case "$1" in
"e") $(dirname $0)/gate_elim.sh
break;;
"h") $(dirname $0)/man.sh
exit
break;;
"") break;;
*)
break;;
  esac
done

> $(dirname $0)/gr.tmp
echo -e "\e[1;96mThe inventory contains:\e[0m\n"
echo -e "\e[37m"
awk -F ',' '{print$1}' $(dirname $0)/fgroup.list | tail -n +2 | pr -T7 -W90
echo -e "\e[0m"
echo

checkgr=`cat $(dirname $0)/gr.tmp`
while [ "$checkgr" == "" ]
  do
echo -en "\e[32mEnter the group:\e[0m "
read gr
if [[ "$gr" == "s" ]]
  then
  $(dirname $0)/spider.sh
  elif [[ "$gr" == "elim" ]]
  then
  $(dirname $0)/gate_elim.sh
  elif [[ "$gr" == "h" ]]
  then $(dirname $0)/man.sh
  else
for i in `cat $(dirname $0)/fgroup.list`; do
echo $i | grep "^$gr," >> $(dirname $0)/gr.tmp
done;
checkgr=`cat $(dirname $0)/gr.tmp`
fi
done
checkgrbd=`cat $(dirname $0)/fgroup.list | grep "^$gr" | awk -F "," '{print$6}'`
#echo -e "\e[33mSP-info about online gates:\e[0m"
$(dirname $0)/spbd.sh $checkgrbd
echo -e "\n"

w=`awk -F "," '{print$1}' $(dirname $0)/gr.tmp` # GROUP NUMBER
x=`awk -F "," '{print$2}' $(dirname $0)/gr.tmp` # NUMBER OF HOSTS
y=`awk -F "," '{print$3}' $(dirname $0)/gr.tmp` # IPSET?
z=`awk -F "," '{print$4}' $(dirname $0)/gr.tmp` # W/DNS?

while true; do
case "$1" in
"c") $(dirname $0)/announcer.sh $w $x $z $y
     $(dirname $0)/enhosts.sh $x  
     $(dirname $0)/spcomparator.sh
     $(dirname $0)/prexecutor.sh $x $y $z
     break;;
 *)

echo -e "\e[1;36m\nCHOOSE THE OPERATION:\e[0m"
echo -e "\e[32m1. Check group (May press \e[36mEnter\e[0m).\e[0m"
echo -e "2. \e[1mSwitch\e[0m group."
echo -e "3. \e[1mInstall\e[0m new gate."
echo -e "4. \e[1mAdd\e[0m domains."
echo -e "5. \e[1mDelete\e[0m domains."
echo -e "6. \e[1mInstall\e[0m IPSET."
echo -e "7. \e[1mEliminate\e[0m the gate."
echo -e "8. \e[1mCheck SSL on domains."
echo -e "H. \e[1mHelp.\e[0m"
echo -e "X. \e[1mClear system.\e[0m"
echo -e "N. \e[1mWHAT'S NEW.\e[0m"
echo -e "T. \e[1mSubmit\e[0m a ticket."
echo -e "Z. \e[1mExit.\e[0m"


while true; do
 read action
 case "$action" in
      1|"")$(dirname $0)/announcer.sh $w $x $z $y
	   $(dirname $0)/enhosts.sh $x 
	   $(dirname $0)/spcomparator.sh
     $(dirname $0)/prexecutor.sh $x $y $z
     $(dirname $0)/backup.sh $w
    break;;
      [2]) $(dirname $0)/announcer.sh $w $x $z $y
	   $(dirname $0)/enhosts.sh $x
     $(dirname $0)/spcomparator.sh
	   $(dirname $0)/prexecutor.sh $x $y "S"
     $(dirname $0)/backup.sh $w
    break;;
      [3]) $(dirname $0)/new_gate.sh $y
    break;;
      [4]) $(dirname $0)/announcer.sh $w $x $z $y
      $(dirname $0)/enhosts.sh $x
      $(dirname $0)/spcomparator.sh
      $(dirname $0)/prexecutor.sh $x $y "W" $z
      $(dirname $0)/backup.sh $w
    break;;
      [5]) $(dirname $0)/announcer.sh $w $x $z $y
      $(dirname $0)/enhosts.sh $x
      $(dirname $0)/spcomparator.sh
      $(dirname $0)/prexecutor.sh $x $y "D"
      $(dirname $0)/backup.sh $w
    break;;
      [6]) $(dirname $0)/ipset.sh $z $y
    break;;
      [7]) $(dirname $0)/gate_elim.sh
    break;;
      [8]) $(dirname $0)/ssl_check.sh
    break;;
      [h]) $(dirname $0)/man.sh
    exit;;
      [x]) $(dirname $0)/cleaner.sh 
    break;;
      [n]) cat $(dirname $0)/verlog
    break;;
      [t]) $(dirname $0)/ticket.sh
    break;;
      [z]) 
    break;;
      *) echo Please answer 1-Z
      ;;
 esac
done
$(dirname $0)/cleaner.sh
$(dirname $0)/ssv.sh
echo "********************************************************************************************" >> $(dirname $0)/report.log
exit;
esac
done
$(dirname $0)/cleaner.sh
$(dirname $0)/ssv.sh "c"
