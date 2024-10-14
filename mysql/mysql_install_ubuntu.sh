#!/bin/bash

## https://dev.mysql.com/downloads/mysql/
## Ubuntu install mysql 8.0.38

apt install build-essential cmake bison libncurses5-dev libssl-dev pkg-config libtirpc-dev

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

# cd /opt

# ## install cmake
# if [ ! -f "cmake-3.25.0.tar.gz" ]; then 
#     # file not found, download
#     wget https://github.com/Kitware/CMake/releases/download/v3.25.0/cmake-3.25.0.tar.gz
#     echo "cmake下载完毕."
# fi

# if [ -d "cmake-3.25.0" ]; then 
#     echo "cmake-3.25.0 目录已存在, 删除."
#     rm -rf cmake-3.25.0
# fi

# tar xvf cmake-3.25.0.tar.gz
# cd cmake-3.25.0 && ./configure
# gmake && make install

cd /opt

## install boost
if [ ! -f "boost_1_77_0.tar.bz2" ]; then 
    # file not found, download
    wget https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.tar.bz2
    echo "boost_1_77_0.tar.bz2下载完毕"
fi

if [ -d "boost_1_77_0" ]; then 
    echo "boost_1_77_0 目录已存在, 删除."
    rm -rf boost_1_77_0
fi

tar xvf boost_1_77_0.tar.bz2
cd boost_1_77_0
./bootstrap.sh
./b2 install

cd /opt

# install mysql
if [ ! -f "mysql-8.0.38.tar.gz" ]; then 
    wget https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-8.0.38.tar.gz
    echo "mysql-8.0.38.tar.gz下载完毕"
fi

if [ -d "mysql-8.0.38" ]; then
    echo "mysql-8.0.38 目录已存在, 删除."
    rm -rf mysql-8.0.38
fi

## 解压
tar zxvf mysql-8.0.38.tar.gz && cd mysql-8.0.38

cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/data/mysql/mysql.sock \
-DDEFAULT_CHARSET=utf8mb4 \
-DDEFAULT_COLLATION=utf8mb4_general_ci \
-DWITH_EXTRA_CHARSETS=all \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DMYSQL_DATADIR=/data/mysql \
-DMYSQL_USER=mysql \
-DMYSQL_TCP_PORT=3306 \
-DSYSCONFDIR=/usr/local/mysql \
-DINSTALL_SHAREDIR=share \
-DWITH_DEBUG=0 \
-DWITH_SSL=system \
-DWITH-mysqld-ldflags=-all-static \
-DWITH-client-ldflags=-all-static \
-DWITH_EMBEDDED_SERVER=OFF \
-DWITH_BOOST=/opt/boost_1_77_0 \
-DFORCE_INSOURCE_BUILD=ON

make -j 4
make install

# 将安装目录的权限更改为 mysql 用户
sudo chown -R mysql:mysql /usr/local/mysql

# 初始化数据库
/usr/local/mysql/bin/mysqld --initialize --user=mysql 
# --basedir=/usr/local/mysql --datadir=/data/mysql

# root@webserver:/# /usr/local/mysql/bin/mysqld --initialize --user=mysql
# 2024-07-16T05:47:17.208787Z 0 [System] [MY-013169] [Server] /usr/local/mysql/bin/mysqld (mysqld 8.0.38) initializing of server in progress as process 124068
# 2024-07-16T05:47:17.218402Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
# 2024-07-16T05:47:17.512013Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
# 2024-07-16T05:47:18.601195Z 6 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: vs;fk:h&d1eZ

# 启动MySQL服务
/usr/local/mysql/support-files/mysql.server start > /dev/null 2>&1

#  配置环境变量
echo 'export PATH=$PATH:/usr/local/mysql/bin' >> ~/.bashrc
source ~/.bashrc

# 运行安全设置脚本
echo "-----------------------------"
echo "run the security setup script"
echo -e "/usr/local/mysql/bin/mysql_secure_installation "
echo -e "-----------------------------\n"

echo "use mysql -uroot -p login."
echo "done."
