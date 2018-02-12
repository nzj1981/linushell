#!/bin/sh
##2017.11.07
IPT=/sbin/iptables
$IPT -F
$IPT -X
$IPT -P INPUT DROP
$IPT -P OUTPUT ACCEPT
$IPT -P FORWARD ACCEPT 

$IPT -A INPUT -m state --state INVALID -j LOG --log-level 4 --log-prefix 'iptable-118-InvalidDrop '
$IPT -A INPUT -m state --state INVALID -j DROP
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A INPUT -j LOG --log-level 4 --log-prefix 'iptable-118-In'
$IPT -A OUTPUT -m limit -j LOG --log-level 4 --log-prefix 'iptable-118-Out'
$IPT -A INPUT -p icmp -j ACCEPT
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A INPUT -s 127.0.0.1 -j ACCEPT

#Custom open ports
$IPT -A INPUT -s 10.120.20.118/22 -p tcp --dport 10022 -j DROP
$IPT -A INPUT -d 111.161.38.122 -p tcp --dport 81 -j DROP
$IPT -A INPUT -d 111.161.38.122 -p tcp --dport 10022 -j ACCEPT
$IPT -A INPUT -s 10.120.20.118/22 -p tcp --dport 22 -j ACCEPT
$IPT -A INPUT -p tcp -m multiport --dports 808,53,80,25,110,443 -j ACCEPT
$IPT -A INPUT -p udp --dport 21:65534  -j ACCEPT
$IPT -A INPUT -s 10.120.20.118/22 -d 10.120.20.118 -p tcp --dport 8088 -j ACCEPT
#$IPT -A INPUT -d 111.161.38.122 -p tcp --dport 8088 -j ACCEPT
#$IPT -A INPUT -d 111.161.38.122 -p tcp --dport 13306 -j ACCEPT
#$IPT -A INPUT -d 111.161.38.122 -m time --timestart 9:00 --timestop 23:59 --weekdays Sat,Sun -p tcp --dport 8088 -j ACCEPT
$IPT -A INPUT -d 111.161.38.122 -m time --timestart 9:00 --timestop 17:00 --weekdays Mon,Tue,Wed,Thu,Fri -p tcp --dport 8088 -j ACCEPT
#$IPT -A INPUT -d 111.161.38.122 -m time --timestart 1:00 --timestop 23:59 --weekdays Mon,Tue,Wed,Thu,Fri -p tcp --dport 8088 -j ACCEPT
#$IPT -A INPUT -d 111.161.38.122 -m time --timestart 9:00 --timestop 23:59 --weekdays Mon,Tue,Wed,Thu,Fri -p tcp --dport 8088 -j ACCEPT
#uvmp_port
#$IPT -A INPUT -p tcp --dport 7745 -j ACCEPT
#$IPT -A INPUT -m time --timestart 9:00 --timestop 17:00 --weekdays Mon,Tue,Wed,Thu,Fri -p tcp --dport 7745 -j ACCEPT
#wangchaunbao client
#$IPT -A INPUT -m time --timestart 9:00 --timestop 17:00 --weekdays Mon,Tue,Wed,Thu,Fri -p tcp --dport 7743 -j ACCEPT
#21.229nginx
$IPT -A INPUT -p tcp --dport 8081 -j ACCEPT
$IPT -A INPUT -p tcp --dport 8082 -j ACCEPT
$IPT -A INPUT -p tcp --dport 8443 -j ACCEPT
#21.225gateway
$IPT -A INPUT -p tcp --dport 8050 -j ACCEPT
#20.118redmine
$IPT -A INPUT -s 10.120.20.0/22 -d 10.120.20.118 -p tcp --dport 81 -j ACCEPT
#localhost open 3389
#$IPT -A INPUT -p tcp --dport 3389 -j ACCEPT
#$IPT -A INPUT -p tcp --dport 3350 -j ACCEPT

iptables-save > /etc/sysconfig/iptables
iptables -L
