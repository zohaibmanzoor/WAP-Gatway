#!/bin/bash
rm -rf /tmp/temp1.txt
touch /tmp/temp1.txt
a=`find /var/log/squid -mmin -30 -name "access*" -type f -exec ls {} +`
for i in a
do
        if [[ $a == *"gz" ]]
        then
                zcat $a >>/tmp/temp1.txt
        elif [[ $a == *"log" ]]
        then
                cat $a >>/tmp/temp1.txt
        fi
done
if [[ -f /tmp/temp1.txt ]]
then
        grep -v "localhost" /tmp/temp1.txt| awk -v cur_date=`date -d '25 minutes ago' "+%d/%b/%Y:%H:%M:%S"` '$1 > cur_date {split($5,a,"/"); print a[2]}'| sort -rn | uniq -c > /home/error_count.txt
else
        echo "">/home/error_count.txt
fi
