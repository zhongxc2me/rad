#!/bin/bash

## https://dev.mysql.com/downloads/mysql/
## Almalinux install mysql 8.0.36

sudo yum update -y
sudo yum groupinstall "Development Tools" -y
sudo yum install -y perl perl-ExtUtils-MakeMaker

yum install -y gcc-toolset-12-gcc gcc-toolset-12-gcc-c++ \ 
gcc-toolset-12-binutils gcc-toolset-12-annobin-annocheck \ 
gcc-toolset-12-annobin-plugin-gcc rpcgen 

## https://mirrors.tuna.tsinghua.edu.cn/centos-stream/9-stream/CRB/x86_64/os/Packages/
rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/centos-stream/9-stream/CRB/x86_64/os/Packages/libtirpc-devel-1.3.3-2.el9.x86_64.rpm

cd /usr/local/src/mysql-8.0.36 && mkdir build && cd build

cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
         -DMYSQL_DATADIR=/usr/local/mysql/data \
         -DSYSCONFDIR=/etc \
         -DWITH_BOOST=../boost \
         -DWITH_SSL=system \
         -DWITH_UNIT_TESTS=off \
         -DDEFAULT_CHARSET=utf8mb4 \
         -DDEFAULT_COLLATION=utf8mb4_general_ci \
         -DENABLED_LOCAL_INFILE=on

# 编译安装
sudo make && make install

# 将安装目录的权限更改为 mysql 用户
sudo chown -R mysql:mysql /usr/local/mysql

# 初始化数据库
sudo /usr/local/mysql/bin/mysqld --initialize --user=mysql



# https://cdn.mysql.com//Downloads/MySQL-8.0/mysql-boost-8.0.36.tar.gz

# 安装MySQL报错处理解决方案
# https://blog.csdn.net/l1028386804/article/details/105508896
# https://blog.csdn.net/u010383467/article/details/128380774