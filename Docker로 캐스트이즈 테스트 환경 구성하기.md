# Docker for Castis

## LSM/VOD Docker Image down
```
```

## Network 생성
```
docker network create --subnet=xxx.xxx.xxx.0/24 {NetworkName}  // IP 및 NetworkName 수정
```

## VOD Docker Run 
* VOD Docker start
```
docker run --name lim-vod${temp} -v /data/contents:/data1 --net lim-net --ip xxx.xxx.xxx.${temp} --rm -d {ImageName}:{Version}  // /data/contents, IP, ImageName, Version 수정
```
* VOD Docker stop
```
docker stop $(docker ps -a -q -f name=lim-vod)  // NetworkName 수정
```
* Start scripts 작성 예시
```
#!/bin/bash

if [ $1 -gt 253 ]
then
	echo "vod count max : 253"
	exit
fi

for temp in `seq $1`
do
	if [ $temp -eq 1 ]
	then
		continue
	fi
	docker run --name lim-vod${temp} -v /data/contents:/data1 --net lim-net --ip xxx.xxx.xxx.${temp} --rm -d {ImageName}:{Version}  // /data/contents, IP, ImageName, Version 수정
done
```

* VOD Container 실행 예시
```
./{start_scripts} count // count-1 개만큼 실행됨.
```

* 종료 스크립트 작성 예시
```
#!/bin/bash

docker stop $(docker ps -a -q -f name=lim-vod)  // NetworkName 수정
```

* VOD Container 종료 예시 
```
./{stop_scripts}
```

## LSM Docker Run
* LSM Docker start
```
# 사전에 /data/CiLLBServer.cfg를 환경에 맞게 수정 필요
docker run --name lim-llb -v /data:/data --net lim-net --ip 192.168.15.100 -p 888:888 -p 8082:8082 --rm -d lim-llb:6.7
```

* start scripts 작성 예시
```
# 스크립트 실행위치 내 config/CiLLBServer.cfg_xxx 가 존재 해야 함
---
#!/bin/bash

LBCFG="config/CiLLBServer.cfg_viettel"

VOD_COUNT=`docker network inspect lim-net | grep lim-vod -A3 | awk -F"\"|/" '/IPv4/{print $4}'|wc -l`

rm -f /data/CiLLBServer.cfg
cp ${LBCFG} /data/CiLLBServer.cfg

echo "The_Number_Of_Servers=${VOD_COUNT}" >>  /data/CiLLBServer.cfg
index=0
for vod_ip in `docker network inspect lim-net | grep lim-vod -A3 | awk -F"\"|/" '/IPv4/{print $4}'`
do
	echo "Server${index}_Address=${vod_ip}" >> /data/CiLLBServer.cfg
	(( index++ ))
done
	



docker run --name lim-llb -v /data:/data --net lim-net --ip 192.168.15.100 -p 888:888 -p 8082:8082 --rm -d lim-llb:6.7

# 888 port : LBAdmin 연결 포트
# 8082 : MonitoringAgent 연결 포트
```

* stop
```
docker stop lim-llb
```