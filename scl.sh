#echo "Welcome to client-sided SoMD!"

#echo -e "*******************************************\e[1;31mWARNING!\e[0m"****************************************
#echo
#echo -e "\e[1;31mBy accessing this program, you approve, that you do not have FAIL-domains at monitoring.\e[0m"

#echo "WHAT'S NEW:"
#echo "Added: Client-Server autobuy handler:"
#echo "****** Full and Last-Failed monitoring."
#echo "****** Dedicated Client and Server executors."
echo -e "\e[1;36m\nCHOOSE THE OPERATION:\e[0m"
echo "1. Full monitoring."
echo "2. Last-failed monitoring."
#echo -e "\e[32mSOMD v.0.39\e[0m\n"

while true; do
 read action
 case "$action" in
      1|"") $(dirname $0)/monitor.sh
    break;;
      [2]) $(dirname $0)/autobuy.sh
    break;;
      *) echo Please answer 1-2
      ;;
 esac
done
