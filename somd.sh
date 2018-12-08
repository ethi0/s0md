v=0.43.4.6
echo -e "*******************************************\e[1;31mWARNING!\e[0m"****************************************
echo
echo -e "\e[1;31mBy accessing this program, you approve, that you do not have FAIL-domains at monitoring.\e[0m"

echo "WHAT'S NEW:"
echo "ADDED: DOM-file checker."
echo "****** Improved domain-processor."
echo '****** "Bulletproof" host-processor.'
echo "TO DO: Group recognition with all the rules at autobuy monitoring."
echo -e "\e[32mSOMD v.$v\e[0m\n"
#echo "Choose the operation:"
echo -e "\e[1;36m\nCHOOSE THE OPERATION:\e[0m"
echo "1. Server-sided."
echo "2. Client-sided."

echo v.$v >> $(dirname $0)/way.log

while true; do
 read action
 case "$action" in
      1|"") $(dirname $0)/sv.sh
    break;;
      [2]) $(dirname $0)/cl.sh
    break;;
      *) echo Please answer 1-2
      ;;
 esac
done
