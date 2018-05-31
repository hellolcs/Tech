# Docker for Castis

## LSM/VOD Docker Image down
```
```

## Network 생성
```
docker network create --subnet=xxx.xxx.xxx.0/24 {NetworkName}  // IP 및 NetworkName 수정
```

## VOD Docker Run 
* Start scripts 작성
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

* 종료 스크립트 작성
```
#!/bin/bash

docker stop $(docker ps -a -q -f name=lim-vod)  // NetworkName 수정
```

* VOD Container 실행
```
./{start_scripts} count // count-1 개만큼 실행됨.
```

* VOD Container 종료
```
./{stop_scripts}
```

## LSM Docker Run
* start scripts 작성
```
((LB Config가 /data/CiLLBServer.cfg 에 위채해야 함))
## LB Config 수정 항목 추가 예정
docker run --name lim-llb -v /data:/data --net lim-net --ip xxx.xxx.xxx.xxx --rm -d lim-llb:6.7
```

* stop
```
docker stop lim-llb
```