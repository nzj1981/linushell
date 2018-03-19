#!/bin/bash

num=$#
if [ ${num} -eq 2 ]; then
#backup files
/bin/cp /etc/ssh/sshd_config /etc/ssh/sshd_config_$2
/bin/cp /etc/sudoers /etc/sudoers_$2
/bin/cp /etc/login.defs /etc/login.defs_$2
/bin/cp /etc/pam.d/su /etc/pam.d/su_$2
#user add
/usr/sbin/useradd autumner
/bin/echo "$1" | /usr/bin/passwd --stdin autumner
# add user for root run any command anywhere
sed -ir '92 i## add user run any command anywhere\nautumner   ALL=(ALL)   ALL' /etc/sudoers

#General users disable Su
sed -i '6 s/^#//' /etc/pam.d/su
sed -ir '14 i#General users disable Su\nSU_WHEEL_ONLY yes' /etc/login.defs
#change ssh profile
sed -ir '13 i#autumner-2018-03-21\nPermitRootLogin no\nUseDNS no\nGSSAPIAuthentication no\n#autumner-2018-03-21\n' /etc/ssh/sshd_config
/etc/init.d/sshd reload
else
 echo "$0 passwd user_date"
 exit 0
fi
