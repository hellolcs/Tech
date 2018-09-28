# 설치 ([파일 다운로드](http://apache.tt.co.kr/zookeeper/))
- 압축 해제 및 링크 생성
```
$ tar -xvf zookeeper-3.4.9.tar.gz
$ ln -sf zookeeper-3.4.9 zookeeper
```

# 설정
- zoo.cfg 변경
```
$ vi zookeeper/conf/zoo.cfg
-----------------------------------------------
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
dataDir=/data/zookeeper/tmp
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
maxClientCnxns=0
maxSessionTimeout=60000
server.1=hadoop:2888:3888
server.2=hadoop01:2888:3888
server.3=hadoop02:2888:3888
```
- log 폴더 변경
```
$ vim zookeeper/bin/zkEnv.sh
-----------------------------------------------
(하단에 추가)
ZOO_LOG_DIR=/data2/log/zoo_log
```
- ID 생성 (자신에 맞는 ID로 생성)
```
$ mkdir -p /data/zookeeper/tmp
$ echo "1" > /data/zookeeper/tmp/myid
```

# 압축 및 배포
- 압축
```
$ tar -cvjpf zookeeper-castis zookeeper-3.4.9
```
- 배포
```
$ scp zookeeper-castis 10.1.1.x
```
- 다른 서버에서도 위와 동일한 작업 진행

# 실행
```
zookeeper/bin/zkServer.sh start
``` 