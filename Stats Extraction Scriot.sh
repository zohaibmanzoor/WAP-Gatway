#Queries
select from_unixtime(clock) as Date,value as 'Total HTTP Requests/sec'  from history Where itemid IN (Select itemid from items where name='Total HTTP Requests/sec') and from_unixtime(clock)>@s_date and from_unixtime(clock)<@e_date
select value as 'Total HTTP Errors/sec'  from history Where itemid IN (Select itemid from items where name='Total HTTP Errors/sec') and from_unixtime(clock)>@s_date and from_unixtime(clock)<@e_date
select value as vWAPSR from history Where itemid IN (Select itemid from items where name='vWAP SR') and from_unixtime(clock)>@s_date and from_unixtime(clock)<@e_date;
select value as 'Total Kbytes In'  from history Where itemid IN (Select itemid from items where name='Total Kbytes In') and from_unixtime(clock)>@s_date and from_unixtime(clock)<@e_date;
select value as 'Total Kbytes Out'  from history Where itemid IN (Select itemid from items where name='Total Kbytes Out') and from_unixtime(clock)>@s_date and from_unixtime(clock)<@e_date;

#Script
#!/bin/bash
last_date=`date -d "1 day ago"  "+%Y-%m-%d"`
s_time=`echo $last_date 00:00:00`
e_time=`echo $last_date 23:59`
mysql -uroot -psecret zabbixdb -e "set @s_date='$s_time'; set @e_date='$e_time';source q1.sql;">/home/temp1.txt
mysql -uroot -psecret zabbixdb -e "set @s_date='$s_time'; set @e_date='$e_time';source q1.sql;">/home/temp2.txt
mysql -uroot -psecret zabbixdb -e "set @s_date='$s_time'; set @e_date='$e_time';source q3.sql;">/home/temp3.txt
mysql -uroot -psecret zabbixdb -e "set @s_date='$s_time'; set @e_date='$e_time';source q4.sql;">/home/temp4.txt
mysql -uroot -psecret zabbixdb -e "set @s_date='$s_time'; set @e_date='$e_time';source q5.sql;">/home/temp5.txt
paste /home/temp1.txt /home/temp2.txt /home/temp3.txt /home/temp4.txt /home/temp5.txt  | sed 's/\t/,/g' > vWAPGW-Stats-`echo $last_date`.csv