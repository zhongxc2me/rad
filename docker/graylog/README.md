## 安装docker-compose
```
# https://github.com/docker/compose/releases/download/v2.29.6/docker-compose-linux-x86_64
sudo curl -L "https://github.com/docker/compose/releases/download/v2.29.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 给予执行权限
sudo chmod +x /usr/local/bin/docker-compose

# 查看是否安装成功
docker-compose --version
```

## 拉取镜像
```
# 稳定版本
docker pull mongo:4.4.6
# 稳定版本
docker pull elasticsearch:7.13.2
# 下载最新版本，去docker官网查看
docker pull graylog/graylog:4.2-jre11

```