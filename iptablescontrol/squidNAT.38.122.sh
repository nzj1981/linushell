#!/bin/bash
IPT=/sbin/iptables
echo 1 > /proc/sys/net/ipv4/ip_forward
$IPT -t nat -F
$IPT -t nat -X
modprobe iptables_nat
$IPT -t nat -A POSTROUTING -j MASQUERADE
#内网机访问指定的互联网地址
$IPT -t nat -A POSTROUTING -s 10.120.21.225 -d 106.14.118.55 -p tcp --dport 8112 -j SNAT --to 111.161.38.122
#刘万龙短信转发接口
#$IPT -t nat -A POSTROUTING -s 10.120.20.69 -d 113.31.86.200 -p tcp --dport 443 -j SNAT --to 111.161.38.122
#$IPT -t nat -A POSTROUTING -s 10.120.20.69 -d 113.31.86.200 -p tcp --dport 80 -j SNAT --to 111.161.38.122
#$IPT -t nat -A POSTROUTING -s 10.120.20.69 -d 113.31.86.200 -p tcp --dport 8080 -j SNAT --to 111.161.38.122
#$IPT -t nat -A POSTROUTING -s 10.120.20.69 -d 113.31.86.200 -p tcp --dport 10050 -j SNAT --to 111.161.38.122
$IPT -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to 202.99.96.68
$IPT -t nat -A PREROUTING -i Auto_eth1 -p tcp -s 10.120.20.0/22 --dport 80 -j REDIRECT --to-ports 808
#20.212windows
$IPT -t nat -A PREROUTING -d 111.161.38.122 -p tcp --dport 13389 -j DNAT --to 10.120.20.212:3389
#21.229nginx
$IPT -t nat -A PREROUTING -d 111.161.38.122 -p tcp --dport 8081 -j DNAT --to 10.120.21.229:8081
$IPT -t nat -A PREROUTING -d 111.161.38.122 -p tcp --dport 8443 -j DNAT --to 10.120.21.229:8443
$IPT -t nat -A PREROUTING -d 111.161.38.122 -p tcp --dport 8082 -j DNAT --to 10.120.21.229:8082
$IPT -t nat -A PREROUTING -d 111.161.38.122 -p tcp --dport 443 -j DNAT --to 10.120.21.229:443
#uvmp22.119
$IPT -t nat -A PREROUTING -d 111.161.38.122 -p tcp --dport 7745 -j DNAT --to 10.120.22.119:7743
#wangchuanbao client
$IPT -t nat -A PREROUTING -d 111.161.38.122 -p tcp --dport 7743 -j DNAT --to 10.120.20.131:7743
#21.225gateway
$IPT -t nat -A PREROUTING -d 111.161.38.122 -p tcp --dport 8050 -j DNAT --to 10.120.21.225:8050
#mysql110
#$IPT -t nat -A PREROUTING -d 111.161.38.122 -p tcp --dport 13306 -j DNAT --to 10.120.21.110:3306
iptables-save > /etc/sysconfig/iptables
$IPT -t nat -L -n
