#!/bin/bash
#author autumner
#date 20180124

now=`date +%Y%m%d%H%M%S`
webappPath=/ego/webapp
backupPath=/ego/backup

#create backup floder
if [ ! -d "$backupPath" ]; then
mkdir "$backupPath"
fi
#searche war path
for t in `find $webappPath -name '*.war'`
do
#warPath=${t%/*}
#warFile=${t##*/}
warPath=$(dirname $t)
warFile=$(basename $t)
#publish war program
if [ -f "./$warFile" ]; then
#backup war file
cp "${t}" "${backupPath}/$(basename $t .war)_${now}.war"
#cp "${t}" "${backupPath}/${warFile}_${now}"
echo -e "\033[32m [$warFile] buckup success! \033[0m"
sleep 1 
chmod 777 ./$warFile
mv -v "./$warFile" "$warPath/" > /dev/null
#mv -v "./$warFile" "/root/" >/dev/null
echo -e "\033[34m [$warFile] update publish success! \033[0m"
else
echo -e "\033[31m local ($warFile) does not exist \033[0m"
fi
sleep 2
unset -v warPath warFile
done
