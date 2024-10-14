docker run --name mysql -e MYSQL_ROOT_PASSWORD="123456" -d mysql:8.4.2

### 启动新的镜像，设置server-id和开启logbin
docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD="123456" -d mysql:8.0.13 --server-id=1 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --log-bin=mysql-bin --sync_binlog=1

create user 'sync_root'@'%' identified by '123456';
grant replication slave on *.* to 'sync_root'@'%';
flush privileges;


docker run --name slave --link mysql:mysql-master -e MYSQL_ROOT_PASSWORD="123456" -d mysql:8.0.13 --server-id=2 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci


CHANGE MASTER TO MASTER_HOST='192.168.98.137',MASTER_USER='root',MASTER_PASSWORD='123456',MASTER_LOG_FILE='mysql-bin.000003',MASTER_LOG_POS=858;

docker rm $(docker stop mysql) && docker rm $(docker stop slave)








docker rm $(docker stop mysql-master) && docker rm $(docker stop mysql-slave)

### 主数据库容器
```
docker run -d --name mysql-master 
-e MYSQL_ROOT_PASSWORD=123456 
-v /opt/docker/mysql/master/data:/var/lib/mysql 
-v /opt/docker/mysql/master/conf:/etc/mysql/conf.d 
-p 3306:3306 
mysql:8.4.2
```

### 切换mysql数据库
use mysql;

### 创建用户slave并授权,slave为用户名，通配符%表示任意ip,密码为123456
create user 'slave'@'%' identified with mysql_native_password by '123456';

### 给slave用户授权
grant replication slave on *.* to 'slave'@'%';

### 刷新权限
flush privileges;

### 查询主服务器状态，并记录File和Position的值
show binary log status;

#### 主配置
```
[mysql]
#设置mysql客户端默认字符集
default-character-set=UTF8MB4
[mysqld]
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
init_connect='SET collation_connection = utf8_unicode_ci'
init_connect='SET NAMES utf8'
#设置3306端口
port=3306
#允许最大连接数
max_connections=200
#允许连接失败的次数
max_connect_errors=10

#服务端使用的字符集默认为8比特编码的latin1字符集
character-set-server=UTF8MB4
#开启查询缓存
explicit_defaults_for_timestamp=true
#创建新表时将使用的默认存储引擎
default-storage-engine=INNODB
#等待超时时间秒
wait_timeout=60
#交互式连接超时时间秒
interactive-timeout=600
#使用mysql_native_password验证密码
mysql_native_password=on

#主服务器唯一ID
server-id=4
#启用二进制日志
log-bin=mysql-bin
#设置不要复制的数据库(可设置多个)
binlog-ignore-db=mysql
binlog-ignore-db=information_schema
#设置需要复制的数据库需要复制的主数据库名字
binlog-do-db=myDatabase
binlog_format=ROW

[mysqld_safe]
log-error=/var/log/mysql/mysql.log
pid-file=/var/run/mysql/mysql.pid

```

### 从数据库容器
```
docker run -d --name mysql-slave 
-e MYSQL_ROOT_PASSWORD=123456 
-v /opt/docker/mysql/slave01/data:/var/lib/mysql 
-v /opt/docker/mysql/slave01/conf:/etc/mysql/conf.d 
-p 3307:3306 
mysql:8.4.2

```

```
# 如若之前同步过可执行改行代码
STOP REPLICA;
RESET REPLICA;

CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.98.137',
SOURCE_PORT=53306,
SOURCE_USER='slave',
SOURCE_PASSWORD='123456',
SOURCE_LOG_FILE='mysql-bin.000003',
SOURCE_LOG_POS=1623;

#开始复制主服务器数据
START REPLICA;
 
#查看从库复制情况
SHOW REPLICA STATUS\G;


[mysql]
#设置mysql客户端默认字符集
default-character-set=UTF8MB4
[mysqld]
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
init_connect='SET collation_connection = utf8_unicode_ci'
init_connect='SET NAMES utf8'
#设置3306端口
port=3306
#允许最大连接数
max_connections=200
#允许连接失败的次数
max_connect_errors=10

#服务端使用的字符集默认为8比特编码的latin1字符集
character-set-server=UTF8MB4
#开启查询缓存
explicit_defaults_for_timestamp=true
#创建新表时将使用的默认存储引擎
default-storage-engine=INNODB
#等待超时时间秒
wait_timeout=60
#交互式连接超时时间秒
interactive-timeout=600
#使用mysql_native_password验证密码
mysql_native_password=on

#从服务器唯一ID
server-id=44
#启用中继日志
relay-log=mysql-relay
#使得更新的数据写进二进制日志中
log-slave-updates=1

#需要主从复制的数据库 ，如多个则重复配置
replicate-do-db=myDatabase
#复制过滤：也就是指定哪个数据库不用同步（mysql库一般不同步） ，如多个则重复配置
binlog-ignore-db=mysql
#为每个session分配的内存，在事务过程中用来存储二进制日志的缓存
binlog_cache_size=1M
#主从复制的格式（mixed,statement,row，默认格式是statement。建议是设置为row，主从复制时数据更加能够统一）
binlog_format=row
#配置二进制日志自动删除/过期时间，单位秒，默认值为2592000，即30天；8.0.3版本之前使用expire_logs_days，单位天数，默认值为0，表示不自动删除。
binlog_expire_logs_seconds=2592000
#跳过主从复制中遇到的所有错误或指定类型的错误，避免slave端复制中断，默认OFF关闭，可选值有OFF、all、ddl_exist_errors以及错误码列表。8.0.26版本之前使用slave_skip_errors
#如：1062错误是指一些主键重复，1032错误是因为主从数据库数据不一致
slave_skip_errors=1062
#relay_log配置中继日志，默认采用 主机名-relay-bin 的方式保存日志文件
relay_log=replicas-mysql-relay-bin
log_slave_updates=ON
#防止改变数据(只读操作，除了特殊的线程)
read_only=ON

[mysqld_safe]
log-error=/var/log/mysql/mysql.log
pid-file=/var/run/mysql/mysql.pid

```

-- 创建用户
CREATE USER 'zhongxc'@'%' IDENTIFIED WITH mysql_native_password BY '123456';

-- 授予权限
GRANT SELECT, INSERT, UPDATE, DELETE ON myDatabase.* TO 'zhongxc'@'%';

-- 刷新权限
FLUSH PRIVILEGES;


```
-- 查看binglog日志
mysqlbinlog --no-defaults -v -v --base64-output=DECODE-ROWS /opt/docker/mysql/master/data/mysql-bin.000004


perl /opt/binlog_rollback.pl -f /opt/docker/mysql/master/data/mysql-bin.000003 -h 127.0.0.1 -u 'root' -p '123456' -P 3306 -i -o '/tmp/a.sql' 2>/dev/null

## 恢复数据
mysql -h 127.0.0.1 -uroot -p123456 -P53306 myDatabase < /tmp/a.sql



tcpdump -i ens33 'port 8066 and (host 10.10.0.4 or 10.10.0.3)' -w a.pcap

tcpdump -r a.pcap

tcpdump -i any 'port 3306 and (host 10.10.0.1 or 10.10.0.2 or 10.10.0.3 or 10.10.0.4)' -nn

```

















###keepalived mysql高可用
```
apt install keepalived

// 查看mysql进程
ps aux | grep mysqld -w | grep -v grep


## keepalived心跳抓包
tcpdump -i ens33 vrrp -nn

## 从192.168.98.137服务器，/etc/profile.d/目录下，拷贝java.sh文件到本机的当前指定目录 .
scp kings@192.168.98.137:/etc/profile.d/java.sh .


nohup /opt/amoeba/bin/amoeba start > log.log 2>&1 &

```