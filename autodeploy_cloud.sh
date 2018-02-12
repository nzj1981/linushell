#!/bin/bash
#author autumner
#date 20180124

now=`date +%Y%m%d%H%M%S`
webappPath=/ego/webapp
backupPath=/ego/webapp/backup

#create backup floder
if [ ! -d "$backupPath" ]; then
mkdir "$backupPath"
fi
#searche war path
for t in `find $webappPath -name '*.war'`
do
warPath=${t%/*}
warFile=${t##*/}
#backup war file
cp "${t}" "${backupPath}/${warFile}_${now}"
echo -e "\033[32m $warFile buckup success! \033[0m"
sleep 1 
#publish war program
if [ -f "./$warFile" ]; then
chmod 777 ./$warFile
mv -v "./$warFile" "$warPath/" > /dev/null
#mv -v "./$warFile" "/root/" >/dev/null
echo -e "\033[34m $warFile publish success! \033[0m"
fi
sleep 2
unset -v warPath warFile
done
