for port in $(seq 1 1); \
do \
mkdir -p /my_data/docker/config/es0${port}
mkdir -p /my_data/docker/data/elastic/es0${port}
mkdir -p /my_data/docker/plugins/es0${port}
cat << EOF > /my_data/docker/config/es0${port}/elasticsearch.yml
cluster.name: es_cluster
node.name: es_0${port}_m
node.master: true
node.data: false
network.host: 10.0.112.240
http.port: 9500
transport.tcp.port: 9600
discovery.zen.minimum_master_nodes: 1
discovery.seed_hosts: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
discovery.zen.fd.ping_timeout: 1m
discovery.zen.fd.ping_retries: 5
cluster.initial_master_nodes: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
http.cors.enabled: true
http.cors.allow-origin: "*"
EOF
docker run --name es_0${port}_m --network=host --privileged=true \
-e ES_JAVA_OPTS="-Xms256m -Xmx256m" \
-e TAKE_FILE_OWNERSHIP=true \
-v /my_data/docker/config/es0${port}/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /my_data/docker/data/elastic/es0${port}:/usr/share/elasticsearch/data \
-v /my_data/docker/plugins/es0${port}:/usr/share/elasticsearch/plugins \
-d elasticsearch:7.9.2
done

docker run --name es_01_m --network=host --privileged=true \
-e ES_JAVA_OPTS="-Xms256m -Xmx256m" \
-e TAKE_FILE_OWNERSHIP=true \
-v /my_data/docker/config/es01/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /my_data/docker/data/elastic/es01:/usr/share/elasticsearch/data \
-v /my_data/docker/plugins/es01:/usr/share/elasticsearch/plugins \
-d elasticsearch:7.9.2




for port in $(seq 2 2); \
do \
mkdir -p /my_data/docker/config/es0${port}
mkdir -p /my_data/docker/data/elastic/es0${port}
mkdir -p /my_data/docker/plugins/es0${port}
cat << EOF > /my_data/docker/config/es0${port}/elasticsearch.yml
cluster.name: es_cluster
node.name: es_0${port}_m
node.master: true
node.data: false
network.host: 10.0.112.241
http.port: 9500
transport.tcp.port: 9600
discovery.zen.minimum_master_nodes: 1
discovery.seed_hosts: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
discovery.zen.fd.ping_timeout: 1m
discovery.zen.fd.ping_retries: 5
cluster.initial_master_nodes: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
http.cors.enabled: true
http.cors.allow-origin: "*"
EOF
docker run --name es_0${port}_m --network=host --privileged=true \
-e ES_JAVA_OPTS="-Xms256m -Xmx256m" \
-e TAKE_FILE_OWNERSHIP=true \
-v /my_data/docker/config/es0${port}/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /my_data/docker/data/elastic/es0${port}:/usr/share/elasticsearch/data \
-v /my_data/docker/plugins/es0${port}:/usr/share/elasticsearch/plugins \
-d elasticsearch:7.9.2
done

docker run --name es_02_m --network=host --privileged=true \
-e ES_JAVA_OPTS="-Xms256m -Xmx256m" \
-e TAKE_FILE_OWNERSHIP=true \
-v /my_data/docker/config/es02/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /my_data/docker/data/elastic/es02:/usr/share/elasticsearch/data \
-v /my_data/docker/plugins/es02:/usr/share/elasticsearch/plugins \
-d elasticsearch:7.9.2



for port in $(seq 3 3); \
do \
mkdir -p /my_data/docker/config/es0${port}
mkdir -p /my_data/docker/data/elastic/es0${port}
mkdir -p /my_data/docker/plugins/es0${port}
cat << EOF > /my_data/docker/config/es0${port}/elasticsearch.yml
cluster.name: es_cluster
node.name: es_0${port}_m
node.master: true
node.data: false
network.host: 10.0.112.254
http.port: 9500
transport.tcp.port: 9600
discovery.zen.minimum_master_nodes: 1
discovery.seed_hosts: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
discovery.zen.fd.ping_timeout: 1m
discovery.zen.fd.ping_retries: 5
cluster.initial_master_nodes: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
http.cors.enabled: true
http.cors.allow-origin: "*"
EOF
docker run --name es_0${port}_m --network=host --privileged=true \
-e ES_JAVA_OPTS="-Xms256m -Xmx256m" \
-e TAKE_FILE_OWNERSHIP=true \
-v /my_data/docker/config/es0${port}/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /my_data/docker/data/elastic/es0${port}:/usr/share/elasticsearch/data \
-v /my_data/docker/plugins/es0${port}:/usr/share/elasticsearch/plugins \
-d elasticsearch:7.9.2
done



for port in $(seq 4 4); \
do \
mkdir -p /my_data/docker/config/es0${port}
mkdir -p /my_data/docker/data/elastic/es0${port}
mkdir -p /my_data/docker/plugins/es0${port}
cat << EOF > /my_data/docker/config/es0${port}/elasticsearch.yml
cluster.name: es_cluster
node.name: es_0${port}_n
node.master: false
node.data: true
network.host: 10.0.112.240
http.port: 9501
transport.tcp.port: 9601
discovery.zen.minimum_master_nodes: 1
discovery.seed_hosts: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
discovery.zen.fd.ping_timeout: 1m
discovery.zen.fd.ping_retries: 5
cluster.initial_master_nodes: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
http.cors.enabled: true
http.cors.allow-origin: "*"
EOF
docker run --name es_0${port}_n --network=host --privileged=true \
-e ES_JAVA_OPTS="-Xms256m -Xmx256m" \
-e TAKE_FILE_OWNERSHIP=true \
-v /my_data/docker/config/es0${port}/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /my_data/docker/data/elastic/es0${port}:/usr/share/elasticsearch/data \
-v /my_data/docker/plugins/es0${port}:/usr/share/elasticsearch/plugins \
-d elasticsearch:7.9.2
done

docker run --name es_04_n --network=host --privileged=true \
-e ES_JAVA_OPTS="-Xms256m -Xmx256m" \
-e TAKE_FILE_OWNERSHIP=true \
-v /my_data/docker/config/es04/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /my_data/docker/data/elastic/es04:/usr/share/elasticsearch/data \
-v /my_data/docker/plugins/es04:/usr/share/elasticsearch/plugins \
-d elasticsearch:7.9.2



for port in $(seq 5 5); \
do \
mkdir -p /my_data/docker/config/es0${port}
mkdir -p /my_data/docker/data/elastic/es0${port}
mkdir -p /my_data/docker/plugins/es0${port}
cat << EOF > /my_data/docker/config/es0${port}/elasticsearch.yml
cluster.name: es_cluster
node.name: es_0${port}_n
node.master: false
node.data: true
network.host: 10.0.112.241
http.port: 9501
transport.tcp.port: 9601
discovery.zen.minimum_master_nodes: 1
discovery.seed_hosts: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
discovery.zen.fd.ping_timeout: 1m
discovery.zen.fd.ping_retries: 5
cluster.initial_master_nodes: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
http.cors.enabled: true
http.cors.allow-origin: "*"
EOF
docker run --name es_0${port}_n --network=host --privileged=true \
-e ES_JAVA_OPTS="-Xms256m -Xmx256m" \
-e TAKE_FILE_OWNERSHIP=true \
-v /my_data/docker/config/es0${port}/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /my_data/docker/data/elastic/es0${port}:/usr/share/elasticsearch/data \
-v /my_data/docker/plugins/es0${port}:/usr/share/elasticsearch/plugins \
-d elasticsearch:7.9.2
done

docker run --name es_05_n --network=host --privileged=true \
-e ES_JAVA_OPTS="-Xms256m -Xmx256m" \
-e TAKE_FILE_OWNERSHIP=true \
-v /my_data/docker/config/es05/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /my_data/docker/data/elastic/es05:/usr/share/elasticsearch/data \
-v /my_data/docker/plugins/es05:/usr/share/elasticsearch/plugins \
-d elasticsearch:7.9.2



for port in $(seq 6 6); \
do \
mkdir -p /my_data/docker/config/es0${port}
mkdir -p /my_data/docker/data/elastic/es0${port}
mkdir -p /my_data/docker/plugins/es0${port}
cat << EOF > /my_data/docker/config/es0${port}/elasticsearch.yml
cluster.name: es_cluster
node.name: es_0${port}_n
node.master: false
node.data: true
network.host: 10.0.112.254
http.port: 9501
transport.tcp.port: 9601
discovery.zen.minimum_master_nodes: 1
discovery.seed_hosts: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
discovery.zen.fd.ping_timeout: 1m
discovery.zen.fd.ping_retries: 5
cluster.initial_master_nodes: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
http.cors.enabled: true
http.cors.allow-origin: "*"
EOF
docker run --name es_0${port}_n --network=host --privileged=true \
-e ES_JAVA_OPTS="-Xms256m -Xmx256m" \
-e TAKE_FILE_OWNERSHIP=true \
-v /my_data/docker/config/es0${port}/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /my_data/docker/data/elastic/es0${port}:/usr/share/elasticsearch/data \
-v /my_data/docker/plugins/es0${port}:/usr/share/elasticsearch/plugins \
-d elasticsearch:7.9.2
done





# 设置集群名称，集群内所有节点的名称必须一致。
cluster.name: es_cluster
# 设置节点名称，集群内节点名称必须唯一。
node.name: es_02
# 表示该节点会不会作为主节点，true表示会；false表示不会
node.master: true
# 当前节点是否用于存储数据，是：true、否：false
node.data: true
# 索引数据存放的位置
#path.data: /usr/share/elasticsearch/data
# 日志文件存放的位置
#path.logs: /usr/share/elasticsearch/logs
# 需求锁住物理内存，是：true、否：false
#bootstrap.memory_lock: true
# 监听地址，用于访问该es
network.host: 10.0.112.241
# es对外提供的http端口，默认 9200
http.port: 9500
# TCP的默认监听端口，默认 9300
transport.tcp.port: 9600
# 设置这个参数来保证集群中的节点可以知道其它N个有master资格的节点。默认为1，对于大的集群来说，可以设置大一点的值（2-4）
discovery.zen.minimum_master_nodes: 1
# es7.x 之后新增的配置，写入候选主节点的设备地址，在开启服务后可以被选为主节点
discovery.seed_hosts: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
discovery.zen.fd.ping_timeout: 1m
discovery.zen.fd.ping_retries: 5
# es7.x 之后新增的配置，初始化一个新的集群时需要此配置来选举master
cluster.initial_master_nodes: ["10.0.112.240:9600", "10.0.112.241:9600","10.0.112.254:9600"]
# 是否支持跨域，是：true，在使用head插件时需要此配置
http.cors.enabled: true
# “*” 表示支持所有域名
http.cors.allow-origin: "*"