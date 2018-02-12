#!/bin/sh
today=`date +%Y%m%d`
bakPath1="/soft/backup/${today}/job" 
bakPath2="/soft/backup/${today}/nojob"
sourcePath1="/soft/source/job"
sourcePath2="/soft/source/nojob"
targetPath1="/soft/app/uvmp_uap/WEB-INF/repository/application/plugins"
targetPath2="/soft/nzj"
sourcetxt1="/soft/source/job.txt"
sourcetxt2="/soft/source/nojob.txt"
#echo $today $bakPath1
if [ ! -d "$bakPath1" ]; then
mkdir -p "$bakPath1"
fi

if [ ! -d "$bakPath2" ]; then
mkdir -p "$bakPath2"
fi
if [ ! -d "$sourcePath1" ]; then
mkdir -p "$sourcePath1"
fi
if [ ! -d "$sourcePath2" ]; then
mkdir -p "$sourcePath2"
fi
# job program  backup and update 
if [ "`ls -Ar $sourcePath1/`" != "" ]; then
###sed -nr 's/(^uvmp_.*)(_[0-9].)(.*jar$)/\1\2/gp'把以uvmp开头和jar结尾的文件名按照(_[0-9].)分割成三部分元素
###通过(\0,\1,\2,\3)实现显示第一、二部分元素
ls -t $sourcePath1 | sed -nr 's/(^uvmp_.*)(_[0-9].)(.*jar$)/\1/gp'> $sourcetxt1
for i in `cat $sourcetxt1`
do
if [ "`ls -Ar $targetPath1/$i* 2>/dev/null`" != "" ]; then
mv $targetPath1/$i* $bakPath1/
fi
done
mv -t $targetPath1/ $sourcePath1/*
echo "***job program update success!***"
else
echo "==job program not update!==="
fi
#no job rogram  backup and update 
if [ "`ls -Ar $sourcePath2/`" != "" ]; then
ls -t $sourcePath2 | sed -nr 's/(^uvmp_.*)(_[0-9].)(.*jar$)/\1/gp'> $sourcetxt2
for i in `cat $sourcetxt2`
do
if [ "`ls -Ar $targetPath2/$i* 2>/dev/null`" != "" ]; then
mv $targetPath2/$i* $bakPath2/
fi
done
mv -t $targetPath2/ $sourcePath2/*
echo "***no job program update success!***"
else
echo "===no job program not update!==="
fi



