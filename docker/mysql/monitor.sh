#!/bin/bash

dt=`date '+%Y-%m-%d %H:%M:%S'`

mysqlmasterprocess=`docker ps | grep "mysql-master" | grep -ivE "grep|cron" | awk '{ print $1}'`
if [ -z $mysqlmasterprocess ]
then
    # docker start mysql-master
    # echo "[$dt] docker start mysql-master success" >> logs.log
    systemctl stop keepalived
    echo "192.168.98.137 mysql已关闭, keepalived以成功关闭" | mail -s "mysql服务关闭了" 1028504601@qq.com
fi


havejava=`ps aux | grep java | grep -v grep`
if [ -z $havejava ]
then
    systemctl stop keepalived
    echo "192.168.98.137 java已关闭, keepalived以成功关闭" > log.log
fi