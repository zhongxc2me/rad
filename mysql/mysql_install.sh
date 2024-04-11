#!/bin/bash

## https://dev.mysql.com/downloads/mysql/
## Almalinux install mysql 8.0.36

sudo yum update -y
sudo yum groupinstall "Development Tools" -y
sudo yum install -y perl perl-ExtUtils-MakeMaker \
gcc-toolset-12-gcc gcc-toolset-12-gcc-c++ \
gcc-toolset-12-binutils gcc-toolset-12-annobin-annocheck \
gcc-toolset-12-annobin-plugin-gcc rpcgen 

sudo dnf install -y make cmake bison ncurses ncurses-devel openssl-devel

if ! rpm -qa | grep -q libtirpc-devel; then 
    ## https://mirrors.tuna.tsinghua.edu.cn/centos-stream/9-stream/CRB/x86_64/os/Packages/
    rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/centos-stream/9-stream/CRB/x86_64/os/Packages/libtirpc-devel-1.3.3-2.el9.x86_64.rpm
fi

# 检查mysql用户组是否存在
if ! getent group mysql > /dev/null; then
    # 创建mysql用户组
    sudo groupadd mysql
    echo "用户组mysql已创建"
else 
    echo "用户组mysql已存在"
fi

if ! id -u mysql > /dev/null 2>&1; then 
    # 创建mysql用户
    sudo useradd -r -g mysql -s /sbin/nologin mysql
    echo "用户mysql已创建"
else 
    echo "用户mysql已存在"
fi

cd /usr/local/src/

# 判断MySQL源码文件是否存在
if [ ! -f "mysql-boost-8.0.36.tar.gz" ]; then 
    # MySQL源码文件不存在，则在线下载
    echo ">"
    echo "==============mysql-boost-8.0.36.tar.gz start download...================"
    wget https://cdn.mysql.com//Downloads/MySQL-8.0/mysql-boost-8.0.36.tar.gz
    echo "download completed"
fi

# 检查目录是否已存在，存在则删除
if [ -d "mysql-8.0.36" ]; then 
    echo "mysql-8.0.36, 目录已存在，正在删除"
    rm -rf mysql-8.0.36
fi

# 解压
tar zxvf mysql-boost-8.0.36.tar.gz

# 判断解压后的文件夹是否存在
if [ ! -d "mysql-8.0.36" ]; then
    echo 'mysql-8.0.36 folder does not exist'
    exit
fi

cd mysql-8.0.36 && mkdir build && cd build

# 检查cmake命令是否存在
if command -v cmake &>/dev/null; then 
    # cmake命令存在，继续执行后续操作
    cmake --version
else 
    echo "cmake not install"
    exit 1
fi

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
# temporary password is generated for root@localhost: Ij9JpyTheV.v

# 启动MySQL服务
/usr/local/mysql/support-files/mysql.server start

#  配置环境变量
echo 'export PATH=$PATH:/usr/local/mysql/bin' >> ~/.bashrc
source ~/.bashrc

# 运行安全设置脚本
echo "run the security setup script"
echo "/usr/local/mysql/bin/mysql_secure_installation \n\n"


echo "use mysql -uroot -p test login."
echo "done."















# https://cdn.mysql.com//Downloads/MySQL-8.0/mysql-boost-8.0.36.tar.gz

# 安装MySQL报错处理解决方案
# https://blog.csdn.net/l1028386804/article/details/105508896
# https://blog.csdn.net/u010383467/article/details/128380774