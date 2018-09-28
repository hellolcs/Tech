# kafka 설치
##  download
[https://kafka.apache.org/downloads](https://kafka.apache.org/downloads)

##  설치
- Tomcat 처럼 압축만 풀어서 사용
```
tar -xvf kafka_2.11-0.11.0.0.tgz
```

#   Zookeeper 설정 및 실행 
-  설정 변경
```
vim config/zookeeper.properties

(추가)
initLimit=5 
syncLimit=2 
server.1=1.255.85.213:2888:3888    #server.X의 X및 IP는 kafka 서버들의 인스턴트 id 및 IP와 맞아야 함
server.2=1.255.85.216:2888:3888 
server.3=1.255.85.217:2888:3888
```
- 디렉토리 생성 및 인스턴트 ID 생성
```
mkdir /tmp/zookeper
echo 1>/tmp/zookeeper/myid  (자신의 ID 값을 넣어야 함)
```
- 종료 스크립트 수정 (ps 출력 결과물에 따라 필요 없을 수 있음)
```
vim bin/zookeeper-server-stop.sh

(아래 부분 변경 : QuorumPeerMain -> zookeeper-gc.log)
PIDS=$(ps ax | grep java | grep -i zookeeper-gc.log| grep -v grep | awk '{print $1}')
// ps ax 시 라인이 너무 길어서 QuorumPeerMain  가 출력안됨…)
```
- 실행 
```
bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
``` 

#   kafka broker 설정 및 실행 

- 설정 변경
```
 vim config/server.properties

(아래 부분을 환경에 맞게끔 수정)
broker.id=1    #자신의 ID
zookeeper.connect=1.255.85.212:2181,1.255.85.213:2181,1.255.85.217:2181  (ZooKeeper 인스턴스 정보 입력)

(추가)
auto.create.topics.enable=false  (해당 설정을 포함할지는 고민 필요 // Topic을 자동으로 생성할지 여부)
```


- hostname 추가
```
vim /etc/hosts
1.255.85.211 DEV-VM-BMT-GFM-MG-1
1.255.85.213 DEV-VM-GFM-MG-2
1.255.85.217 DEV-VM-NSCOMM-MG
```
- 종료 스크립트 수정 (ps 출력 결과물에 따라 필요 없을 수 있음)
```
vim config/kafka-server-stop.sh

(아래 부분 변경 : kafka\.kafka -> kafkaServer-gc.log)
PIDS=$(ps ax | grep -i 'kafkaServer-gc.log' | grep java | grep -v grep | awk '{print $1}')

// ps ax 시 라인이 너무 길어서 kafka\.kafka 가 출력안됨...
```
- 실행 
```
bin/kafka-server-start.sh -daemon config/server.properties 
```