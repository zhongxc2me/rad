for i in $(seq 1 3); \
do \
docker run -p 637${i}:6379 -p 1637${i}:16379 \
--name redis-${i} \
-v /docker/redis/node-${i}/data:/data \
-v /docker/redis/node-${i}/conf/redis.conf:/etc/redis/redis.conf \
--net redis \
--ip 172.18.0.1${i} \
-d redis redis-server /etc/redis/redis.conf
done

for i in $(seq 1 3); \
do \
docker rm $(docker stop redis-${i})
done

cp //mnt/hgfs/shares/docker/ /


## 创建集群
docker exec -it redis-1 bash
redis-cli --cluster create 172.18.0.11:6379 172.18.0.12:6379 172.18.0.13:6379

# 进入集群，再任何一个节点上执行
redis-cli -c
cluster info
cluster nodes

xcopy /s /e /y .\docker\redis\node-1\* node-2\
xcopy /s /e /y .\docker\redis\node-1\* .\docker\redis\node-2\
xcopy /s /e /y .\docker\redis\node-1\* .\docker\redis\node-3\