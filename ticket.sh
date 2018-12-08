read -p "Enter your name: " name
read -p "Enter your wishes|propositions here: " tick
echo -e "[\e[1;96m`date`\e[0m : $name :$tick" | tee -a $(dirname $0)/enhostdom/tickets
echo Thanks!
