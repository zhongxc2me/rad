### MySQL配置自启动
vim /etc/systemd/system/mysqld.service

```
[Unit]
Description=MySQL Server
After=network.target

[Service]
ExecStart=/usr/local/mysql/bin/mysqld_safe --user=mysql
ExecStop=/usr/local/mysql/bin/mysqladmin shutdown
ExecReload=/usr/local/mysql/bin/mysqladmin reload
User=mysql
Group=mysql

[Install]
WantedBy=multi-user.target
```
#### 重新加载 systemd
sudo systemctl daemon-reload

#### 设置开机自启
sudo systemctl enable mysqld

### MySQL修改root远程访问权限
```
mysql -u root -p
use mysql;
select host, user from user;
update user set host='%' where user='root';
flush privileges;
```