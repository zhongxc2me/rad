#!/bin/bash

yum install -y gcc tcl

cd /usr/local/src/

if [ ! -f "redis-7.2.4.tar.gz" ]; then 
    # Redis源码文件不存在，直接在线下载
    echo ">"
    echo "==============redis-7.2.4.tar.gz start download...================"
    wget https://github.com/redis/redis/archive/7.2.4.tar.gz
    echo "download completed"
fi

# 判断解压后的文件夹是否存在
if [ ! -d "redis-7.2.4.tar.gz" ]; then
    echo 'redis-7.2.4.tar.gz folder does not exist'
    exit
fi

tar zxvf redis-7.2.4.tar.gz

