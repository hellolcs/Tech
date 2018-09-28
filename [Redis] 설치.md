    
※ TestBed Edge#1 LSM에 구성됨

## Redis 설치

**1. Redis.tar.bz 압축해제**
```
 tar -xvf redis-3.2.6.tar.gz
```

**2. redis 설치**
```
 cd redis-3.2.6
 make && make install
 utils/install_server.sh
(port 설정 부분에서 3306/ 또는 원하는 포트)
(config 파일 설정 부분에서 /etc/redis/redis.conf)
```

**3. vi /etc/redis/redis.conf 설정**
```
(수정)
bind 0.0.0.0          ## listen IP
masterauth "castis"   ##복제 동기화 과정이 시작되기 전에 slave의 인증 비밀번호
requirepass "castis"  ##client에게 다른 command들을 수행하기 전에 password를 요구
slaveof 1.255.85.214 3306  ## Slave Redis 서버에 설정

slave-priority 1    # Acive 1, replicate slave 2, sentinel Only slave 0
```

**4. redis 시작 스크립트 변경**
```
 mv /etc/init.d/redis_3306 /etc/init.d/redis
 vim /etc/init.d/redis
(수정)
CLIEXEC -p $REDISPORT -a castis shutdown (43 라인)
```

**5. Redis 실행**
```
 service redis start
```

**6. 확인**
```
 redis-cli -p 3306 -a castis
 info Replication
```

## Sentinel 설치
**1. config 복사**
```
 cp redis-3.2.6/sentinel.conf /etc/redis/
```

**2. 설정 변경**
```
 vi /etc/redis/sentinel.conf
(변경)
sentinel monitor mymaster 192.168.150.214 3306 2    ### Master Redis 정보
sentinel down-after-milliseconds mymaster 3000 

(추가)
bind 0.0.0.0 
sentinel auth-pass mymaster castis                  ### Redis Password
daemonize yes 
pidfile "/var/run/sentinel.pid"
logfile "/var/log/sentinel.log"
```

**3. Sentinel 시작 스크립트 추가**
```
 cp /etc/init.d/redis /etc/init.d/sentinel
```

**4. Sentinel 시작 스크립트 수정**
```
 vim /etc/init.d/sentinel
 :%s/Redis/Sentinel/g        (Redis 부분을 Sentinel 로 변경)

(수정)
EXEC=/usr/local/bin/redis-sentinel

PIDFILE=/var/run/sentinel.pid
CONF="/etc/redis/sentinel.conf"
REDISPORT="26379"

$EXEC $CONF & (33번째 줄)
```

**5. Sentinel 실행**
```
 service sentinel start
```

**6. 확인**
```
 redis-cli -p 26379
 info Sentinel
```