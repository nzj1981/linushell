#!/bin/bash
# ---------------------------------------------------------------
# Author:      nzj
# Created:    2017/03/24
# Copyright:   (c) nzj 2017
# filename: clearExpiredTomcatLogs.sh
# FUNCTION: clear the expired tomcat log files
# Add sys schedule:
# crontab -e
# press "i" enter the Modify mode, and add schedule item in new-line:
# 05 00 * * * /bin/bash /usr/local/clearExpiredTomcatLogs.sh
# press "Esc" key to exit Modify mode, then press "Shift + :" and input "wq", press "Enter" key to exit the crontab
# --------------------------------------------------------------
#the base directory for search the existed apache tomcat.
SEARCH_DIR=/usr/local/
# the keep days of log-files.[config value range: 2 -- 365]
KEEP_LOGFILE_DAYS=3
# execute log for this shell
EXECUTE_LOG_FILE=clear-expired-tomcat-logs.log
# write execute log
function writelog(){
    if [ ! -f "${EXECUTE_LOG_FILE}" ]; then
        touch ${EXECUTE_LOG_FILE}
    fi
    echo "$1">>${EXECUTE_LOG_FILE}
}
# remove expired log files
removeExpiredLogFiles() {
    log_dir=$1
    log_file_prefix_name=$2
    log_file_ext_name=$3
    REMOVED_FILE=1
    LOG_FILE=
    LOG_FILE_NAME=
    CUR_DATE=
    for((i=${KEEP_LOGFILE_DAYS};i<=365;i++));do
        CUR_DATE=$(date +"%Y-%m-%d" --date="-$i day")
        LOG_FILE_NAME=${log_file_prefix_name}${CUR_DATE}${log_file_ext_name}
        LOG_FILE="${log_dir}/${LOG_FILE_NAME}"
        if [ -f "${LOG_FILE}" ]; then
            writelog "${LOG_FILE_NAME}"
            rm -f ${LOG_FILE}
            REMOVED_FILE=0
        fi
    done
    if [ ${REMOVED_FILE} -eq 0 ]; then
        writelog ""
    fi
    unset -v log_file_prefix_name log_file_ext_name
    unset -v LOG_FILE LOG_FILE_NAME CUR_DATE
    return ${REMOVED_FILE}
}
# remove the tomcat's log files
removeExpiredLogFilesForTomcat() {
    log_dir=$1
    # remove log-files that which is out of the keep days.
    removeExpiredLogFiles "${log_dir}" "catalina." ".log"
    a=$?
    removeExpiredLogFiles "${log_dir}" "catalina." ".out"
    b=$?
    removeExpiredLogFiles "${log_dir}" "host-manager." ".log"
    c=$?
    removeExpiredLogFiles "${log_dir}" "manager." ".log"
    d=$?
    removeExpiredLogFiles "${log_dir}" "localhost." ".log"
    e=$?
	removeExpiredLogFiles "${log_dir}" "localhost_access_log." ".txt"
    f=$?
    if [ ${a} -eq 1 -a ${a} -eq ${b} -a ${a} -eq ${c} -a ${a} -eq ${d} -a ${a} -eq ${e} -a ${a} -eq ${f} ]; then
        writelog "# No expired log file"
        writelog ""
    fi
    unset -v log_dir
}
writelog "#-------------------------------------------------START"
writelog "`date +"%Y-%m-%d %A %H:%M:%S"`"
writelog "keep days for tomcat log files: $KEEP_LOGFILE_DAYS"
writelog "remove the expired tomcat log files in the following directories:"
# find the "tomcat" and remove the expired log files
for t in `find $SEARCH_DIR -name '*tomcat*'`
do
    if [ -d "${t}/logs" ]; then
        writelog "${t}/logs/"
        removeExpiredLogFilesForTomcat "${t}/logs"
    fi
done
writelog "#-------------------------------------------------END"
writelog ""
unset -v SEARCH_DIR KEEP_LOGFILE_DAYS EXECUTE_LOG_FILE
unset -f writelog removeExpiredLogFiles removeExpiredLogFilesForTomcat
