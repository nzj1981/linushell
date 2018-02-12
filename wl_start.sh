#!/bin/sh
# ---------------------------------------------------------------
# Name:      wl_start.sh
#
# Author:      nzj
# Note:        weblogic service node start or reboot script.
# Created:    2016/03/30
# Copyright:   (c) nzj 2016
# --------------------------------------------------------------
##set server name and port to array
node_arr=(node1:8001 node2:8002 node3:8001 node4:8002 ejnode:7011)
##set server path
srvpath=/root/Oracle/Middleware/user_projects/domains/tycl_domain/servers
#################################################################################
##set node server commde start path
## How the file ${startIscNode.sh} is generated 
## copy startManagedWebLogic.sh to startIscNode.sh
## Modify the configuration of the file
###  Set SERVER_NAME to the name of the server you wish to start up.
##   DOMAIN_NAME="isc2_domain"
##   ADMIN_URL="http://10.120.20.140:7001"
##   SERVER_NAME=$1
###################################################################################
nodecmd=$srvpath/../bin/nodeServer.sh
##set logs path
WL_LOG_PATH=/app/logs/$1_2016.log
##set server cache path
CACHE_FILE_PATH=/app/publish_program/tycl_cache
##initialize JVM param
USER_MEM_ARGS="-Xms2048m -Xmx2048m -XX:PermSize=512M -XX:MaxPermSize=512m -XX:MaxNewSize=512m -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:CMSFullGCsBeforeCompaction=2 -XX:CMSInitiatingOccupancyFraction=70 -XX:+UseCMSInitiatingOccupancyOnly  -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -Dweblogic.threadpool.MinPoolSize=1000 -Dweblogic.threadpool.MaxPoolSize=1000"
##get local machine ip
# local_ip=$(/sbin/ifconfig eth0 | sed -n '/inet addr/s/^[^:]*:\([0-9.]\{7,15\}\).*/\1/p')
## definition reboot_svr function
# --- Start Functions -------------------------------------------------------------------------------------------------------
function reboot_svr(){ 
  ##kill server node pid
  procCount=$(ps -ef | grep $svrname |grep "Dweblogic.Name=${srvname}"| grep -v "grep" | wc -l)
  if [ $procCount != '0' ]; then
  ps -ef | grep $svrname |grep "Dweblogic.Name=${srvname}"| grep -v "grep" | awk '{print $2}' | while read pid
  do 
     kill -9 $pid
  done
  echo -e "\e[0;31m *** $svrname pid is killed ***\e[0m"
  fi
  echo ""
  sleep 1
  #clear server node cache
  rm -fr $CACHE_FILE
  echo -e "\e[0;31m *** $svrname service cache file is clear ***\e[0m"
  echo ""
  sleep 2
  echo -e "\e[0;31m *** $svrname service is starting ***\e[0m"
  echo ""
  export USER_MEM_ARGS
  ##create logs file
  if [ ! -f "$WL_LOG" ]; then
	touch "$WL_LOG"
  fi
  # start server node and Generate log records in accordance with 200M
  nohup ${nodecmd} $svrname > $WL_LOG 2>&1 & 
  tail -f $WL_LOG
  exit 1
}
# --- End Functions ---------------------------------------------------------------------------------------------------------------
##set user use sh
if [ `whoami` != 'root' ]; then
	echo 'Login User error'
	exit 9
fi
##master program starting
if [ -n "$1" ]; then
	if [ -d "$srvpath/$1" ]; then
		WL_LOG=$WL_LOG_PATH
		CACHE_FILE=$CACHE_FILE_PATH/$1/*
		svrname=$1
		reboot_svr $CACHE_FILE $svrname $WL_LOG;
	else
       echo -e "\e[0;31m local machine does not have $1 service,please check...\e[0m"
       exit 1	
	fi
else
	echo -e "\e[0;31m please $0 [${node_arr[@]%:*}] \e[0m"
	exit 1
fi
