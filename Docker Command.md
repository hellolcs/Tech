# Docker Command

* Docker Image 찾기
```
docker search [image_name]
docker search centos
```

* Docker Image download
```
docker image pull [image_name]:[tag]
docker iamge pull centos:6.7
```

* Docker start (run)
```
docker run -h centos-6-lim --name centos-6-lim --net lim-net --ip 192.168.15.3 -v /root/lim/share:/share --rm -it centos:6.7 /bin/bash  
# -h : hostname
# --name : docker container name
# --net : docker network / must be created network before run
# -v : mount host storage
# --rm : kill container after exit shell
# -it : enable input terminal
```
** Docker run 옵션
```
옵션  설명
-d  detached mode 흔히 말하는 백그라운드 모드
-p  호스트와 컨테이너의 포트를 연결 (포워딩)
-v  호스트와 컨테이너의 디렉토리를 연결 (마운트)
-e  컨테이너 내에서 사용할 환경변수 설정
–name   컨테이너 이름 설정
–rm 프로세스 종료시 컨테이너 자동 제거
-it -i와 -t를 동시에 사용한 것으로 터미널 입력을 위한 옵션
–link   컨테이너 연결 [컨테이너명:별칭]
--net   network 선택 / 도커 네트워크가 생성 되어
```

** Docker start#2 (User Application run)
```
docker run --name lim-test --net lim-net --ip 192.168.15.3 --rm -d lim-vod2:6.7
# -d : detach mode
```

* Remove multiple terminated processes
```
docker rm -v $(docker ps -a -q -f status=exited)
# rm -v : remove connected data volume
# -a : all container
# -f : filter
# -q : print only container ID
```

* Connect running container
```
docker exec -it lim-test /bin/bash
```

* Docker show ip list
```
docker inspect -f '{{.Name}} - {{.NetworkSettings.IPAddress }}' $(docker ps -aq)
```