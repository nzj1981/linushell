#!/bin/bash
#author nzj
#date 20171017

now=`date +%Y%m%d%H%M%S`
tomcatPath=/usr/local/tomcat
backupPath=/usr/local/tomcat/backup
war=$1
if [ -e "$war.war" ]; then
echo -e "\033[34m war archive: $war.war \033[0m"
else
echo -e "\033[31m war archive '$war.war' not exists \033[0m"
echo -e "\033[31m please execute $0 war filename  \033[0m"
exit -1
fi
# change color
echo -e "\033[34m"
# create backup dir
if [ ! -d "$backupPath" ]; then
mkdir "$backupPath"
fi
echo "tomcat home: $tomcatPath"
echo "backup path: $backupPath"
echo 'try to stop tomcat...'
pid=`ps aux|grep "java"|grep "$tomcatPath"|awk '{printf $2}'`
if [ -n $pid ]; then
echo "tomcat pid:$pid";
kill -9 $pid
#sh $tomcatPath/bin/shutdown.sh
fi
sleep 15 
echo 'stop tomcat finished...'
sleep 5
echo 'backup old archive...'
if [ -f "$tomcatPath/webapps/$war.war" ]; then
mv -v "$tomcatPath/webapps/$war.war" "$backupPath/$1_$now.war";
fi
rm -rf $tomcatPath/webapps/$war*
echo "mv $war.war archive to webapps.."
mv -v "$war.war" "$tomcatPath/webapps/"
echo -e "\033[32m"
echo 'startup tomcat...'
nohup $tomcatPath/bin/startup.sh > /dev/null 2>&1 &
# change color
echo -e "\033[34m"
sleep 5
tail -10f $tomcatPath/logs/catalina.out
