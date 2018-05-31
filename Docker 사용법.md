# Docker 사용법

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
docker run -h centos-6-lim --name centos-6-lim --net lim-net --ip 192.168.15.3 -v /root/lim/share:/share -it centos:6.7 /bin/bash  
# -h : hostname
# --name : docker container name
# --net : docker network / must be created network before run
# -v : mount host storage
# -it : enable input terminal
```