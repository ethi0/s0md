#set -x
d=`cat /home/user/trash/autolog`


cat trash/autochecklist1 | grep $d | awk -F "," '{print$2}' > trash/autobuygroup

trash/detector.sh
