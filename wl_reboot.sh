#!/bin/sh
# ---------------------------------------------------------------
# Name:       wl_reboot.sh
#
# Author:      nzj
# Note:        weblogic service node start or reboot script.
# Created:    2015/12/03
# Copyright:   (c) nzj 2015
# --------------------------------------------------------------

##initialize JVM param
USER_MEM_ARGS="-Xms2048m -Xmx2048m -XX:PermSize=512M -XX:MaxPermSize=512m -XX:MaxNewSize=512m -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:CMSFullGCsBeforeCompaction=2 -XX:CMSInitiatingOccupancyFraction=70 -XX:+UseCMSInitiatingOccupancyOnly  -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0"
local_ip=$(/sbin/ifconfig eth0 | sed -n '/inet addr/s/^[^:]*:\([0-9.]\{7,15\}\).*/\1/p')
 

function reboot_svr(){ 
##get weblogic node pid program name
var=$(netstat -lnp|grep $ip_port |awk 'NR==1{print $7}')
##get pid
java_pid=${var%/*}
if [ "${java_pid}" != "" ] ; then
  kill -9 $java_pid
  echo -e "\e[0;31m *** $svrname pid is killed ***\e[0m"
  echo ""
  sleep 2
fi
  rm -fr $CACHE_FILE
  echo -e "\e[0;31m *** $svrname service cache file is clear ***\e[0m"
  echo ""
  sleep 3
  echo -e "\e[0;31m *** $svrname service is starting ***\e[0m"
  echo ""
  export USER_MEM_ARGS
  # tycl server weblogic service 
  #nohup /home/weblogic/Oracle/Middleware/user_projects/domains/uap_domain/bin/startManagedWebLogic.sh $svrname http://10.1.180.86:7001 > $WL_LOG 2>&1 &
  #201 test server weblogic service
  nohup /home/weblogic/Oracle/Middleware/user_projects/domains/tycl/bin/startManagedWebLogic.sh $svrname http://127.0.0.1:7065 > $WL_LOG 2>&1 &
  tail -f $WL_LOG
  exit 1
}
case $1 in
  uapnode4 )
    ip_port=10.1.180.85:8002
    WL_LOG=/app/logs/uaplog/uapnode4_2015.log
    CACHE_FILE=/app/publish_program/uap/uapnode4/*
    svrname=$1
    if [[ "$local_ip" == "${ip_port%:*}" ]]; then
    	#statements
    	reboot_svr $ip_port $CACHE_FILE $svrname $WL_LOG;	
    else
       echo -e "\e[0;31m local machine does not have $1 service,please check...\e[0m"
       exit 1	
    fi
 	;;
  uapnode3 )
    ip_port=10.1.180.85:8001
    WL_LOG=/app/logs/uaplog/uapnode3_2015.log
    CACHE_FILE=/app/publish_program/uap/uapnode3/*
    svrname=$1
    if [[ "$local_ip" == "${ip_port%:*}" ]]; then
    	#statements
    	reboot_svr $ip_port $CACHE_FILE $svrname $WL_LOG;	
    else
       echo -e "\e[0;31m local machine does not have $1 service,please check...\e[0m"
       exit 1	
    fi
        ;;
  uapnode2 )
    ip_port=10.1.180.86:8002
    WL_LOG=/app/logs/uaplog/uapnode2_2015.log
    CACHE_FILE=/app/publish_program/uap/uapnode2/*
    svrname=$1
    if [[ "$local_ip" == "${ip_port%:*}" ]]; then
    	#statements
    	reboot_svr $ip_port $CACHE_FILE $svrname $WL_LOG;	
    else
       echo -e "\e[0;31m local machine does not have $1 service,please check...\e[0m"
       exit 1	
    fi
 	;;
  uapnode1 )
    ip_port=10.1.180.86:8001
    WL_LOG=/app/logs/uaplog/uapnode1_2015.log
    CACHE_FILE=/app/publish_program/uap/uapnode1/*
    svrname=$1
    if [[ "$local_ip" == "${ip_port%:*}" ]]; then
    	#statements
    	reboot_svr $ip_port $CACHE_FILE $svrname $WL_LOG;	
    else
       echo -e "\e[0;31m local machine does not have $1 service,please check...\e[0m"
       exit 1	
    fi
 	;;
  Server1 )
    ip_port=10.85.172.201:8065
    WL_LOG=/home/weblogic/uvmp_ucp/uvmp_ucp_2015.log
    CACHE_FILE=/home/weblogic/Oracle/Middleware/user_projects/domains/tycl/servers/Server1/*
    svrname=$1
    if [[ "$local_ip" == "${ip_port%:*}" ]]; then
    	#statements
    	reboot_svr $ip_port $CACHE_FILE $svrname $WL_LOG;	
    else
       echo -e "\e[0;31m local machine does not have $1 service,please check...\e[0m"
       exit 1	
    fi
 	;;
 	* )
	  echo -e "\e[0;31m please $0 [uapnode1|uapnode2|uapnode3|uapnode4|Server1] \e[0m"
	  exit 1
		;;
 esac 
