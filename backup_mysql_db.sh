#!/bin/bash
# author autumner
# date 20180416

# **********************************************************
# 01 05 * * 1,3,5,7 /home/backup_db.sh > /home/back_db.log
# 00 04 * * * find /home/db_back/ -type f -name "*.gz" -mtime +15 -exec rm -fr {} \;
# **********************************************************

now=`date +%Y%m%d%H%M%S`
db_arr=('db1' 'db2' 'db3')
for db in ${db_arr[@]} 
do
mysqldump -uuser -p**** -h127.0.0.1 -P3306 ${db} | gzip -9 | cat > /home/db_back/${db}_${now}.gz
printf "${db} at %s--------------> complete!\n" `date +%Y%m%d%H%M%S`
done

if [ $? -eq 0 ]; then
exit 0
fi


